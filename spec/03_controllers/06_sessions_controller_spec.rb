require 'sinatra_helper'
# require 'controllers_spec_helper'

describe 'SessionsController' do

	before do
		@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
		@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
		@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
		@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
	end

	describe "get '#{login_path}'" do

		it 'loads the login page if not logged in' do
			get login_path
			expect(last_response.status).to eq(200)
			expect_path(:login)
		end

		it 'redirects to /forum_threads if logged in' do
			use_controller_to_login_as(@user1)
			get login_path
			expect_redirect
			expect_path(:forum_threads)
		end

	end


	describe "post '#{login_path}'" do 

		it "renders the login page if login fails" do 
			params = { forum_user: { username: "val", password: "willy" } }
			post login_path, params
			expect(last_response.status).to eq(200)
			expect_path(:login)
		end

		it "redirects to /forum_threads if login succeeds" do
			use_controller_to_login_as(@user1)
			expect_redirect
			expect_path(:forum_threads)
		end

	end

	describe "delete '#{sessions_path}'" do 

		it "redirects to '/' in not logged in" do 
			delete sessions_path 
			expect_redirect
		  	expect_path(:root)
			expect(last_response.body).to include("Sign Up")
			expect(last_response.body).to include("Log In")
		end

		it "redirects to '/' and logs out if logged in" do
			use_controller_to_login_as(@user1)
			delete sessions_path
			expect_redirect
		  	expect_path(:root)
			expect(last_response.body).to include("Sign Up")
			expect(last_response.body).to include("Log In")
		end

	end

end