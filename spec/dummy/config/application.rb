require_relative "boot"
require "logger"
require "active_record/railtie"
require "action_controller/railtie"

Bundler.require(*Rails.groups)
require "rails_rest_kit/engine"

module Dummy
  class Application < Rails::Application
    config.load_defaults 7.0
    config.eager_load = true
    config.secret_key_base = "test_secret_key_base_for_dummy_app"
    
    # Disable unnecessary middleware
    config.middleware.delete ActionDispatch::Static
    config.middleware.delete ActionDispatch::Flash
    config.middleware.delete ActionDispatch::Session::CookieStore
    config.middleware.delete ActionDispatch::Cookies
  end
end