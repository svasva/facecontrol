ActiveAdmin.register Message do
  scope :questions, :default => true
  scope :rumors

  filter :content
  filter :rating

  index do
    column :content
    column :source
    column :target
    column :rating
    column :anonymous do |msg|
      check_box_tag '', 0, msg.anonymous, {:disabled => true}
    end
    default_actions
  end
end
