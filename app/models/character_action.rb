class CharacterAction < ActiveRecord::Base
  belongs_to :user
  belongs_to :action

  include AASM
  aasm_column :status
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :processing
  aasm_state :done
  aasm_state :faled

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
  end

	def process
    Resque.enqueue(CharacterActions)
  end

end
