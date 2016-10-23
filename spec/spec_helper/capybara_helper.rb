Bundler.require(:capybara)
# require 'rack/test'
# require 'capybara/rspec'
# require 'capybara/dsl'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Capybara::DSL
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.ignore_hidden_elements = false
Capybara.app = app