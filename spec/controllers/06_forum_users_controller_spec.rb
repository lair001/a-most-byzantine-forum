require 'spec_helper'

describe 'ForumUsersController' do 

  before do
  	@user = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true)
  end

	describe "get '/login'" do

		it 'loads the login page if not logged in' do
			get '/login'
			expect(last_response.status).to eq(200)
			expect(last_request.path).to include("/login")
			expect(last_response.body).to include("Welcome back!")
		end

		it 'redirects to /forum_threads if logged in' do
			params = {
				forum_user: { username: "val", password: "val" }
			}
			post '/login', params
			get '/login'
			expect(last_response.status).to eq(302)
			follow_redirect!
			expect(last_response.status).to eq(200)
			expect(last_request.path).to include("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

	end

	describe "get '/forum_users/new'" do

	  	it 'loads the signup page if not logged in' do 
	  		get '/forum_users/new'
	  		expect(last_response.status).to eq(200)
			expect(last_request.path).to include("/forum_users/new")
      		expect(last_response.body).to include("Enroll in the Basileus's")
	  	end

		it 'redirects to /forum_threads if logged in' do
		  	params = {
		  		forum_user: { username: "val", password: "val" }
		  	}
		  	post '/login', params
		  	get '/forum_users/new'
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		end

	end

	describe "post '/forum_users/search'" do

		it 'redirects to / if not logged in' do 
			post '/forum_users/search'
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/")
			expect(last_response.body).to include("A Most Byzantine Forum")
		end

		it "redirects to the user's profile page if logged in and username is found" do
			params = {
		  		forum_user: { username: "val", password: "val" }
		  	}
		  	post '/login', params
			post '/forum_users/search', params 
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_users/val")
		  	expect(last_response.body).to include("val")
		end

		it "redirects to the /forum_users with message 'Username not found.' if logged in and username is not found" do
			params = {
		  		forum_user: { username: "val", password: "val" }
		  	}
		  	post '/login', params
			params = { forum_user: { username: "billy" } }
			post '/forum_users/search', params 
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_users")
		  	expect(last_response.body).to include("Users")
		  	expect(last_response.body).to include("Username not found.")
		end

	end

	describe "post '/forum_users'" do 

		it 'redirects to /forum_users/new if it fails to create a new user' do
			params = { forum_user: { username: "val", email: "willy@willy.com", password: "willy" } }
			post '/forum_users', params
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_users/new")
		  	expect(last_response.body).to include("Enroll in the Basileus's")
		end

		it 'redirects to /forum_threads if it creates a new user' do
			params = { forum_user: { username: "willy", email: "willy@willy.com", password: "willy" } }
			post '/forum_users', params
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		  	expect(ForumUser.find_by_slug("willy").username).to eq("willy")
		end

	end

	#   it 'redirects to /forum_threads if logged in' do 
 #      	visit '/login'
 #      	fill_in("username", with: "val")
	# 	fill_in("password", with: "val")
	# 	click_button 'login'
	# 	get '/login'
 #      	expect(last_response.status).to eq(200)
 # #    	expect(last_request.path).to include("/forum_threads")
	#   end



end