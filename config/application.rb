require_relative 'boot'
require 'dotenv/load'
require 'rails/all'
 
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'elasticsearch/rails/instrumentation'
module Platform
  class Application < Rails::Application
    config.root_directory = "/api/"
	  config.action_controller.relative_url_root = '/api'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.allow_concurrency=true
    config.api_only = true
    config.autoload_paths += %W(#{config.root}/lib)
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.middleware.use ActionDispatch::Flash
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    SquareConnect.configure do |config|
      # Configure OAuth2 access token for authorization: oauth2
       #config.access_token = Rails.application.secrets.square_sandbox_accesstoken_id
       config.access_token = Rails.application.secrets.square_access_token
    end
  end
end
