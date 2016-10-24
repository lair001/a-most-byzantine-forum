`ls spec -R | grep 'spec/spec_helper'`.split(":\n").each do |directory|
  $LOAD_PATH << directory
end

ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'spec_helper'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end