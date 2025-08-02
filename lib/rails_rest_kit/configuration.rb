require "rails_rest_kit/flash_defaults"

module RailsRestKit
  include ActiveSupport::Configurable

  config_accessor(:flash_defaults) { FlashDefaults.instance }
end