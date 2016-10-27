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
  post helper.login_path, params
end

def expect_path(symbol)
	expect(last_request.path).to eq(helper.send("#{symbol}_path"))
	expect(last_response.body).to include(helper.send("#{symbol}_page_title")) if helper.respond_to?("#{symbol}_page_title")
	expect(last_response.body).to include(helper.send("#{symbol}_page_tagline")) if helper.respond_to?("#{symbol}_page_tagline")
end