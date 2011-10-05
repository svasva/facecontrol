class CharacterAction < ActiveRecord::Base
  belongs_to :character
  belongs_to :game_action
  belongs_to :target_character, :class_name => 'Character', :foreign_key => 'target_character_id'
  has_one :message

  scope :last_ten, joins(:game_action).where{game_action.default_type != 'stay'}.order('created_at desc').limit(10)
  scope :votes, joins(:game_action).where{game_action.default_type == 'vote'}
  scope :char_uniq, select('distinct(character_actions.character_id)')

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
    self.stop_time = Time.now.utc + self.game_action.ttl.seconds if self.game_action.ttl and self.game_action.ttl > 0
    logger.info "stop_time = #{self.stop_time.to_s(:short)}" if self.stop_time
  end

  # enqueue task to background worker
  # called after CharacterAction#create
	def enqueue
    start_at = self.start_time.nil? ? self.created_at.utc : self.start_time.utc
    start_at += self.game_action.delay.seconds if self.game_action.delay

    if Time.now.utc >= start_at
      Resque.enqueue(CharacterActionWorker, self.id)
    else
      Resque.enqueue_at(start_at, CharacterActionWorker, self.id)
    end
  end

  def repeat_active?
    if self.game_action.repeat
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
    puts "enter PROCESS_ACTION, #{self.inspect}"
    # check stop_time
    if self.stop_time and (Time.now.utc.to_i >= self.stop_time.to_i)
      puts "cancel"
      self.cancel!
      return true
    end
    puts "start! PROCESS_ACTION"
    # mark action as processing after delay checks & so on
    self.start!

    # modify character with corresponding deltas
    begin
      puts "modify! PROCESS_ACTION"
      self.character.modify(self.game_action, self.target_character_id)
      self.character.update_attributes(:updated_at => Time.now.utc)
    rescue => e
      puts "ACHTUNG #{e.inspect}"
    end

    case self.game_action.default_type
    when 'buy_clicks'
      puts "buy_clicks! PROCESS_ACTION"
      self.character.update_attributes(
        :bought_clicks_at => Time.now.utc,
        :paid_clicks => (self.character.paid_clicks + 100)
      )
    when 'vote'
      puts 'vote! PROCESS_ACTION'
      if self.character.paid_clicks > 0
        puts "got paid clicks (#{self.character.paid_clicks}), taking one"
        self.character.update_attributes(:paid_clicks => (self.character.paid_clicks - 1))
      end
    end

    # do something with action.subject
    puts "#{self.game_action.default_type} subject: #{self.game_action.subject.inspect}"
    case self.game_action.subject_type
    when 'Place'
      case self.game_action.default_type
      when 'enter'
        puts "ENTER PLACE! PROCESS_ACTION"
        self.character.update_attributes :place => self.game_action.subject
      when 'leave'
        puts "LEAVE PLACE! PROCESS_ACTION"
        self.character.update_attributes :place => nil
      when 'stay'
        puts "STAY PLACE! PROCESS_ACTION"
        unless self.character.place
          self.cancel!
          return false
          puts "PLACE is NIL! CANCEL STAY!"
        end
      end
    when 'Item'
      case self.game_action.default_type
      when 'buy'
        unless self.game_action.subject.item_type.name == 'drink'
          puts "BUY! adding #{self.game_action.subject.name} to #{self.character.name}"
          self.character.items.clothes.where(:item_id => self.game_action.subject.id).destroy_all
          ci = CharacterItem.create(
            :item => self.game_action.subject,
            :equipped => false,
            :gift => false,
            :wear => 0
          )
          self.character.items << ci
          self.character.put_on(ci)
        end
      when 'gift'
        puts "GIFT! adding #{self.game_action.subject.name} to #{self.target_character.name}"
        self.target_character.items << CharacterItem.create(
          :item => self.game_action.subject,
          :equipped => false,
          :gift => true,
          :wear => 0,
          :source_character_id => self.character_id
        )

      when 'use'
        puts "USED! used #{self.game_action.subject.name} for #{self.character.name} - removing"
        self.character.items.gift_drinks.where(:item_id => self.game_action.subject_id).last.destroy
      end
    end

    # check if we have to disable some actions
    # GameAction.where(:disabler_action_id => self.game_action.id).each
    self.game_action.disabling_actions.each {|action|
      puts "have to cancel action #{action.name}(#{action.id})"
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
    if self.repeat_active? and ca_repeat = self.character.do_action(self.game_action)
      ca_repeat.update_attributes :repeat_index => self.repeat_index + 1
    end

    self.game_action.children.each {|child|
      self.character.do_action(child, self.target_character)
    }
    return true
    # PROCESS
  end

end
