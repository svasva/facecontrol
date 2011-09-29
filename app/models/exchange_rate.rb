class ExchangeRate < ActiveRecord::Base
  has_one :buy_action,
		:as => :subject,
		:class_name => 'Action',
		:conditions => {:default_type => "buy_gold"},
	  :autosave => true,
	  :dependent => :destroy

	 def name
	 	self.game_string
	 end

  def init_default_actions
		if new_record?
			build_buy_action
			buy_action.conditions.build
		end
  end

  def add_names_to_default_actions
		buy_action.name = self.game_string
  end
end
