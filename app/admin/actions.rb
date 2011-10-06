# encoding: utf-8
ActiveAdmin.register GameAction do
  menu :label => 'Actions'
 #belongs_to :item 
 #FIXME! workaround https://github.com/gregbell/active_admin/issues/221 
  controller.belongs_to :place, :item, :polymorphic => true, :optional => true

  filter :name

  scope :without_subject

  index do
    column :id
    column :name
    column :description
  column :conditions do |action|
      div :class => "actions" do
        render "actions/condition_links", :action => action
      end
    end
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :description
      f.input :action_group
      f.input :contest_rating
      f.input :need_target
      f.input :delta_energy
      f.input :delta_glory
      f.input :delta_real_glory
      f.input :delta_drive
      f.input :delta_money
      f.input :delta_wear
      f.input :delta_relation_index
    end
    f.inputs "Timings" do
      f.input :repeat
      f.input :delay
      f.input :ttl
    end
    f.inputs "Relations" do
      f.input :disabler_action
      f.input :children
      f.input :parent
    end 
    f.buttons   
  end
  
end
