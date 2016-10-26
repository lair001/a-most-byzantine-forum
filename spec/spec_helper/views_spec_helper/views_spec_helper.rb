# require 'capybara_spec_helper'

def use_view_to_login_as(user)
  visit helper.login_path
  fill_in("username", with: "#{user.username}")
  fill_in("password", with: "#{user.password}")
  click_button 'login'
end