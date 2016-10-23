ENV["SINATRA_ENV"] = "test"

require_relative '../config/environment'
require 'rack/test'
require 'capybara/rspec'
require 'capybara/dsl'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate SINATRA_ENV=test` to resolve the issue.'
end

ActiveRecord::Base.logger = nil

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end

def app
  Rack::Builder.parse_file('config.ru').first
end

Capybara.ignore_hidden_elements = false
Capybara.app = app

class Request

  attr_accessor :path_info

end

class Errors

  attr_accessor :all

  def initialize
    self.all = []
  end

  def add(symbol, string)
    all << [symbol, string]
  end

  def clear 
    all.clear
  end

end

class Helper

  include ApplicationHelper

  ATTR_ARRAY = [ 
    :session,  
    :user_posts,   
    :threads,
    :users,
    :thread_posts,
    :slug,
    :params,
    :request,
    :thread 
  ]

  ATTR_ARRAY.each { |attr| attr_accessor attr }

  def initialize
    self.request = Request.new
    self.params = {}
  end

  def redirect(string)
    string
  end

  def view_current_user
    @current_user.dup.freeze
  end

end

def expect_redirect
  expect(last_response.status).to eq(302)
  follow_redirect!
  expect(last_response.status).to eq(200)
end

def use_controller_to_login_as(user)
  params = {
    forum_user: { username: "#{user.username}", password: "#{user.password}" }
  }
  post '/login', params
end

def use_view_to_login_as(user)
  visit '/login'
  fill_in("username", with: "#{user.username}")
  fill_in("password", with: "#{user.password}")
  click_button 'login'
end