class User < ApplicationRecord
  has_one :notification_setting, dependent: :destroy
  after_create ->(user) { user.create_notification_setting }
end
