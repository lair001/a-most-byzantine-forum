require 'capybara_spec_helper'

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