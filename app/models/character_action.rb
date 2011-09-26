class CharacterAction < ActiveRecord::Base
  belongs_to :character
  belongs_to :action
  belongs_to :target_character, :class_name => 'Character', :foreign_key => 'target_character_id'
  has_one :message

  scope :last_ten, joins(:action).where{action.default_type != 'stay'}.order('created_at desc').limit(10)
  scope :char_uniq, select('distinct(character_actions.character_id), character_actions.*')

  after_create :enqueue
  before_create :set_stop_time

  # state machine settings
  include AASM
  aasm_column :status
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :processing
  aasm_state :done
  aasm_state :canceled
  aasm_state :failed

  aasm_event :start do
    transitions :from => :pending, :to => :processing
  end

  aasm_event :cancel do
    transitions :from => [:pending, :processing], :to => :canceled
  end

  aasm_event :done do
    transitions :from => :processing, :to => :done
  end

  aasm_event :failed do
    transitions :from => :processing, :to => :failed
  end

  def reset
    self.aasm_enter_initial_state
    self.save
    self.enqueue
  end

  # state machine settings END

  # check ttl and set CharacterAction stop_time
  def set_stop_time
    logger.info 'set stop_time'
    self.stop_time = Time.now.utc + self.action.ttl.seconds if self.action.ttl
    logger.info "stop_time = #{self.stop_time.to_s(:short)}" if self.stop_time
  end

  # enqueue task to background worker
  # called after CharacterAction#create
	def enqueue
    start_at = self.start_time.nil? ? self.created_at.utc : self.start_time.utc
    start_at += self.action.delay.seconds if self.action.delay

    if Time.now.utc >= start_at
      Resque.enqueue(CharacterActionWorker, self.id)
    else
      Resque.enqueue_at(start_at, CharacterActionWorker, self.id)
    end
  end


  def reload_status
    self.status = CharacterAction.find(self.id).status
    self.status
  end

  def repeat_active?
    if self.action.repeat
      logger.info "REPEAT CHECK CharacterAction #{self.id}"
      self.repeat_index = 1 if not self.repeat_index or self.repeat_index == 0
      return true if self.repeat_count == 0
      return true if self.repeat_index < self.repeat_count
      return true if self.stop_time and (Time.now.utc <= self.stop_time)
    end
    return false
  end

  # called from resque
  def process_action
    # check stop_time
    if self.stop_time and (Time.now.utc.to_i >= self.stop_time.to_i)
      logger.info "cancel, #{self.stop_time} | #{self.status}"
      self.cancel!
      return true
    end

    # mark action as processing after delay checks & so on
    self.start!

    # modify character with corresponding deltas
    begin
      self.character.modify(self.action, self.target_character_id)
      self.character.update_attributes(:updated_at => Time.now.utc)
    rescue => e
      logger.error e.inspect
    end

    # do something with action.subject
    logger.info "#{self.action.default_type} subject: #{self.action.subject.inspect}"
    case self.action.subject_type
    when 'Place'
      case self.action_id
      when self.action.subject.enter_action.id, self.action.subject.stay_action.id
        self.character.update_attributes :place => self.action.subject
      when self.action.subject.leave_action.id
        self.character.update_attributes :place => nil
      end
    when 'Item'
      case self.action.default_type
      when 'buy'
        logger.info "BUY! adding #{self.action.subject.name} to #{self.character.name}"
        self.character.character_items << CharacterItem.create(
          :item => self.action.subject,
          :equipped => false,
          :gift => false,
          :wear => 0
        )
      when 'gift'
        logger.info "GIFT! adding #{self.action.subject.name} to #{self.target_character.name}"
        self.target_character.character_items << CharacterItem.create(
          :item => self.action.subject,
          :equipped => false,
          :gift => true,
          :wear => 0,
          :source_character_id => self.id
        )
      end
    end

    # check if we have to disable some actions
    # Action.where(:disabler_action_id => self.action.id).each
    self.action.disabling_actions.each {|action|
      logger.info "have to cancel action #{action.name}(#{action.id})"
      CharacterAction.where(
        :character_id => self.character_id,
        :action_id => action.id,
        :status => ['pending']
      ).each {|ca|
        logger.info "canceling CA ##{ca.id}"
        ca.cancel!
        #ca.save
      }
    }

    # repeat
    if self.repeat_active? and ca_repeat = self.character.do_action(self.action)
      ca_repeat.update_attributes :repeat_index => self.repeat_index + 1
    end

    self.action.children.each {|child|
      self.character.do_action(child, self.target_character)
    }
    return true
    # PROCESS
  end

end
