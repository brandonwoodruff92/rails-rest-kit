require 'bundler/setup'
require 'rspec'

# Load the dummy app
ENV['RAILS_ENV'] ||= 'test'
require_relative 'dummy/config/environment'
# require_relative '../lib/rails_rest_kit'

# Configure RSpec
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed

  # Database cleanup
  config.before(:suite) do
    system("cd spec/dummy && rails db:migrate")
  end

  config.after(:each) do
    # Clean up data after each test
    User.delete_all
    Post.delete_all
  end
end