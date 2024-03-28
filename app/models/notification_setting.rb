class NotificationSetting < ApplicationRecord
  belongs_to :user

  enum frequency: { hourly: 0, daily: 1 }
  validate :validate_before_save

  private

  def validate_before_save
    # errors.add(:next_notification_at, 'must be in the future') if next_notification_at < Time.zone.now
  end
end
