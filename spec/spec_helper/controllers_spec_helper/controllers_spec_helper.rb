# require 'capybara_spec_helper'

def expect_redirect
  expect(last_response.status).to eq(302)
  follow_redirect!
  expect(last_response.status).to eq(200)
end

def use_controller_to_login_as(user)
  params = {
    forum_user: { username: "#{user.username}", password: "#{user.password}" }
  }
  post login_path, params
end

def expect_path(symbol)
	expect(last_request.path).to eq(self.send("#{symbol}_path"))
	expect(last_response.body).to include(self.send("#{symbol}_title")) if self.respond_to?("#{symbol}_title")
	expect(last_response.body).to include(self.send("#{symbol}_tagline")) if self.respond_to?("#{symbol}_tagline")
end