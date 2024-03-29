class ApplicationJob < ActiveJob::Base
  around_perform :handle_exceptions

  private

  def handle_exceptions
    yield
  rescue StandardError => e
    Rails.logger.error "Add a logger for error #{e}"
  end
end
