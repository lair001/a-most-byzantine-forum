require 'database_spec_helper'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'default'
end

BCrypt::Engine::DEFAULT_COST = 4