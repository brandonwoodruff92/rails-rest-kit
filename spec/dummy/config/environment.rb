require_relative "application"

Rails.application.config.root = File.expand_path('..', __dir__)

Dummy::Application.initialize!