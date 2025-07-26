require_relative "lib/rails_rest_kit/version"

Gem::Specification.new do |s|
  s.name           = "rails-rest-kit"
  s.version        = RailsRestKit::VERSION
  s.summary        = "Automated RESTful controller actions with lifecycle callbacks and parameter permitting"
  s.description    = "RailsRestKit provides a comprehensive solution for building RESTful Rails controllers with minimal boilerplate. It automatically generates standard CRUD actions (index, show, new, create, edit, update, destroy) with built-in lifecycle callbacks and validation states (valid/invalid). The gem includes intelligent resource helpers that automatically infer model relationships from controller names, and a flexible parameter permitting system that supports nested attributes and collections. Perfect for rapidly building consistent REST APIs with proper separation of concerns."
  s.authors        = ["Brandon Woodruff"]
  s.email          = "brandonwoodruff92@gmail.com"
  s.require_paths  = ["lib"]
  s.homepage       = "https://github.com/brandonwoodruff92/rails-rest-kit"
  s.license        = "MIT"
  s.files          = Dir["{lib}/**/*"]

  s.required_ruby_version = ">= 2.7.0"
  s.add_dependency "rails", "~> 7.0", ">= 7.0.0"
  # Development dependencies
  s.add_development_dependency "bundler", "~> 2.1"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "rspec", "~> 3.0"
end