require_relative "config/environment"

# Create database
ActiveRecord::Base.connection.create_database("db/test.sqlite3") rescue nil

# Run migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migration.migrate("db/migrate")