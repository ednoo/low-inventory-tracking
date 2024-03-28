class CreateNotificationSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :notification_settings do |t|
      t.datetime :next_notification_at
      t.boolean  :real_time_notification, default: true
      t.boolean :email_notification, default: true
      t.integer :frequency, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
