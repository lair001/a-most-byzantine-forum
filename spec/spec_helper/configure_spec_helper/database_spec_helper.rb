raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.' if ActiveRecord::Migrator.needs_migration?
ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  DatabaseCleaner.strategy = :truncation
  config.before { DatabaseCleaner.clean }
  config.after { DatabaseCleaner.clean }
end