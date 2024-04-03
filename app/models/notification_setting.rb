class NotificationSetting < ApplicationRecord
  belongs_to :user

  enum frequency: { hourly: 0, daily: 1 }

  def update_next_notification_at
    update(next_notification_at: next_notification_at_value)
  end

  private

  def next_notification_at_value
    frequency == 'hourly' ? 1.hour.from_now : 1.day.from_now
  end
end
