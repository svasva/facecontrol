class CreateSocialNotifications < ActiveRecord::Migration
  def change
    create_table :social_notifications do |t|
      t.text :message
      t.timestamp :start_time
      t.string :status
      t.string :progress

      t.timestamps
    end
  end
end
