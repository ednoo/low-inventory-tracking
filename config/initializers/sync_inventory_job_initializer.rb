if defined?(Rails::Server)
  Rails.application.config.after_initialize do
    SyncInventoryJob.perform_later
  end
end
