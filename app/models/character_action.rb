class CharacterAction < ActiveRecord::Base
  belongs_to :character
  belongs_to :action
  belongs_to :target_character, :class_name => 'Character'

  after_create :process
  before_create :set_stop_time

  # state machine settings
  include AASM
  aasm_column :status
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :processing
  aasm_state :done
  aasm_state :failed

  aasm_event :start do
    transitions :from => :pending, :to => :processing
  end

  aasm_event :processed do
    transitions :from => :processing, :to => :done
  end

  aasm_event :failed do
    transitions :from => :processing, :to => :failed
  end

  def reset
    self.aasm_enter_initial_state
    self.save
    self.process
  end

  # state machine settings END

  # check ttl and set CharacterAction stop_time
  def set_stop_time
    self.stop_time = Time.now.utc + self.action.ttl.seconds if self.action.ttl
  end

  # enqueue task to background worker
	def process
    Resque.enqueue(CharacterActionWorker)
  end

  # executes after CharacterAction#create
  def process_action
    logger.info "process entry"
    self.start!

    # check stop_time
    logger.info "stop_time check entry"
    if self.stop_time
      logger.info "stop_time check: #{Time.now.utc.to_i} >= #{self.stop_time.to_i}"
      return true if Time.now.utc.to_i >= self.stop_time.to_i
    end

    # delay
    logger.info "delay_loop entry #{self.action.id}"
    loop do
      start_at = (self.start_time == nil) ? self.created_at.utc : self.start_time.utc
      logger.info "action##{self.action.id} #{Time.now.utc.to_i} >= #{start_at.utc.to_i} + #{self.action.delay}"
      break if Time.now.utc.to_i >= (start_at.to_i + self.action.delay)
      sleep 1
    end

    # process
    self.character.modify(self.action)

    # check if we have to disable some actions
    CharacterAction.where(:disabler_action_id => self.action).each {|ca|
      logger.info "have to disable action #{ca.name}(#{ca.id})"
    }

    # repeat
    if self.action.repeat
      logger.info "REPEAT CHECK CharacterAction #{self.id}"
      self.repeat_index = 1 if not self.repeat_index or self.repeat_index == 0
      if self.repeat_count == 0 or (self.repeat_count and (self.repeat_index < self.repeat_count)) and (Time.now.utc <= self.stop_time)
        logger.info "REPEAT CharacterAction #{self.id}"
        ca_repeat = self.dup
        ca_repeat.status = 'pending'
        ca_repeat.repeat_index += 1
        ca_repeat.save
      else
        logger.info "REPEAT STOP CharacterAction #{self.id}"
      end
    end

    if self.action.has_children
      self.action.children.each {|child|
        CharacterAction.create(
          :action => child,
          :character => self.character,
          :target_character => self.target_character
        )
      }
    end
    return true
    # PROCESS
  end

end
