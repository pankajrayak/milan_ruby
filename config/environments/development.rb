Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  #config.reload_classes_only_on_change = false
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  ActionCable.server.config.disable_request_forgery_protection = true

   #config.debug_exception_response_format = :default
  # Do not eager load code on boot.
  config.eager_load = false
  config.serve_static_assets = false
  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end


#mailcatcher setting

  #mail configuration
   config.action_mailer.perform_deliveries = true
#     #config.action_mailer.default_url_options = { :host => "54.215.241.71" }
   config.action_mailer.default_url_options = { :host => "localhost:3001" }
  config.action_mailer.delivery_method = :smtp
# # SMTP settings for sendGrid
config.action_mailer.smtp_settings = {
  :user_name            => "apikey",
  :password             => "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",
  :domain => "atul@ziggletech.com",
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :authentication       => "plain",
  :enable_starttls_auto => true
}
#end
# config.action_mailer.perform_deliveries = true
# config.action_mailer.default_url_options = { :host => "milan.dev.ziggletech.com/api" }
# config.action_mailer.delivery_method = :smtp
# config.action_mailer.smtp_settings = {
#   :address => 'email-smtp.us-east-1.amazonaws.com',
#   :port => 587,
#   :user_name => 'AKIAJHVWXSKK3SR737IA', #Your SMTP user
#   :password => 'AnITefstlt70nPLJTxScJmzMFSj6EYGMWbBrLtbl04oY', #Your SMTP password
#   :authentication => :login,
#   :enable_starttls_auto => true
# }





  # Don't care if the mailer can't send.
  if config.respond_to?(:action_mailer)
    config.action_mailer.raise_delivery_errors = false
  end

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  #USING ACTIVE STORAGE FOR DOC SAVE
  # Store files on Amazon S3.
#config.active_storage.service = :amazon
end
