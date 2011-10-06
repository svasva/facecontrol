class SocialNotification < ActiveRecord::Base
	after_create :enqueue

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

	def restart
    self.aasm_enter_initial_state
    self.save
    self.enqueue(true)
	end

	def start_at
		self.start_time.nil? ? self.created_at.utc : self.start_time.utc
	end

	def enqueue(restart = false)
    if Time.now.utc >= self.start_at or restart
      Resque.enqueue(CharacterNotifyWorker, self.id)
    else
      Resque.enqueue_at(start_at, CharacterNotifyWorker, self.id)
    end
	end
end
