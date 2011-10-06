ActiveAdmin.register SocialNotification do
	menu :parent => 'Characters'
	index do
		column :message
		column :status
		column :progress do |sn|
			raw "#{sn.progress}, #{link_to 'force restart', restart_admin_social_notification_path(sn)}"
		end
		column :start_at
		default_actions
	end

  form do |f|
    f.inputs "Details" do
      f.input :message
    end
    f.inputs "Timings" do
      f.input :start_time, :input_html => { :class => 'disable-chosen'}
    end
    f.buttons
  end

  member_action :restart do
  	begin
	  	SocialNotification.find(params[:id]).restart
	  	flash[:notice] = 'Notification will be re-sent now'
	  rescue => e
	  	flash[:notice] = 'Something has gone wrong :('
	  ensure
	  	redirect_to :back
	  end
  end
end