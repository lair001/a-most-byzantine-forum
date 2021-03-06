require 'sinatra_helper'
# require 'controllers_spec_helper'

describe 'ForumUsersController' do

	before do
		@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
		@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
		@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
		@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
	end

	describe "get '/forum_users/new'" do

	  	it 'loads the signup page if not logged in' do 
	  		get '/forum_users/new'
	  		expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_users/new")
      		expect(last_response.body).to include("Enroll in the Basileus's")
	  	end

		it 'redirects to /forum_threads if logged in' do
		  	use_controller_to_login_as(@user1)
		  	get '/forum_users/new'
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		end

	end

	describe "post '/forum_users/search'" do

		it 'redirects to / if not logged in' do 
			post '/forum_users/search'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to the user's profile page if logged in and username is found" do
			use_controller_to_login_as(@user1)
		  	params = { forum_user: { username: "val" } }
			post '/forum_users/search', params 
			expect_redirect
		  	expect(last_request.path).to eq("/forum_users/val")
		  	expect(last_response.body).to include("val")
		end

		it "redirects to the /forum_users with message 'Username not found.' if logged in and username is not found" do
			use_controller_to_login_as(@user1)
			params = { forum_user: { username: "billy" } }
			post '/forum_users/search', params 
			expect_redirect
		  	expect(last_request.path).to eq("/forum_users")
		  	expect(last_response.body).to include("Users")
		  	expect(last_response.body).to include("Username not found.")
		end

	end

	describe "post '/forum_users'" do 

		it 'renders /forum_users/new if it fails to create a new user' do
			params = { forum_user: { username: "val", email: "willy@willy.com", password: "willy" } }
			post '/forum_users', params
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_users")
		  	expect(last_response.body).to include("Enroll in the Basileus's")
		end

		it 'redirects to /forum_threads if it creates a new user' do
			params = { forum_user: { username: "willy", email: "willy@willy.com", password: "willy" } }
			post '/forum_users', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		  	expect(ForumUser.find_by_slug("willy").username).to eq("willy")
		end

	end

	describe "get '/forum_users'" do 

		it 'redirects to / if not logged in' do 
			get '/forum_users'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it 'renders forum_user/index if logged in' do
			use_controller_to_login_as(@user1)
			get '/forum_users'
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_users")
			expect(last_response.body).to include("Users")
		end

	end

	describe "get '/forum_users/:slug'" do

		it 'redirects to / if not logged in' do 
			get '/forum_users/val'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "renders the user's profile page if logged in" do
			use_controller_to_login_as(@user1)
			get '/forum_users/val'
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_users/val")
		  	expect(last_response.body).to include("val")
		end

	end

	describe "get '/forum_users/:slug/edit'" do 

		it 'redirects to / if not logged in' do 
			get '/forum_users/val/edit'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to / if accessing another user's edit page when not an administrator" do 
			use_controller_to_login_as(@user3)
			get '/forum_users/val/edit'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "allows an administrator to access another user's edit page" do 
			use_controller_to_login_as(@user4)
			get '/forum_users/sal/edit'
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_users/sal/edit")
			expect(last_response.body).to include("Edit")
		end

		it "allows a non-administrator to access his or her own edit page" do 
			use_controller_to_login_as(@user2)
			get '/forum_users/hal/edit'
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_users/hal/edit")
			expect(last_response.body).to include("Edit")
		end

		describe "patch '/forum_users'" do

			it 'redirects to / if not logged in' do 
				patch '/forum_users'
				expect_redirect
			  	expect(last_request.path).to eq("/")
				expect(last_response.body).to include("Chat About All Things Roman")
			end

			it 'redirects to /forum_users if user is successfully updated' do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank")
				params = {
		  			forum_user: { username: "frank", password: "frank" }
		  		}
		  		post '/login', params
		  		params = { forum_user: { id: @user.id, email: "frank@gmail.com" } }
		  		patch '/forum_users', params
		  		expect_redirect
			  	expect(last_request.path).to eq("/forum_users")
				expect(last_response.body).to include("Users")
			end

			it 'redirects to cached route if there is no user for the given user id' do 
				use_controller_to_login_as(@user1)
		  		params = { cached_route: '/C11P', forum_user: { id: "255", email: "frank@gmail.com" } }
		  		patch '/forum_users', params 
		  		expect_redirect
			  	expect(last_request.path).to eq("/C11P")
				expect(last_response.body).to include("Constantine XI Palaiologos")
			end

			it 'redirects to / if there is no cached route and no user for the given user id' do 
				use_controller_to_login_as(@user1)
		  		params = { forum_user: { id: "255", email: "frank@gmail.com" } }
		  		patch '/forum_users', params 
		  		expect_redirect
			  	expect(last_request.path).to eq("/")
				expect(last_response.body).to include("Chat About All Things Roman")
			end

			it 'allows a moderator to ban a user but cannot change username, email or password' do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank")
				id = @user.id
				use_controller_to_login_as(@user3)
		  		params = { forum_user: { id: @user.id, username: "hank", email: "hank@hank.com", password: "hank", banned: true } }
		  		patch '/forum_users', params 
			  	follow_redirect!
			  	@user = ForumUser.find(id)
		  		expect(@user.username).to eq("frank")
		  		expect(@user.email).to eq("frank@frank.com")
		  		expect(@user.banned).to eq(true)
		  		expect(@user.authenticate("frank")).to eq(@user)
		  		expect(@user.authenticate("hank")).to eq(false)
			end

			it 'allows a moderator to unban a user' do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank", banned: true)
				id = @user.id
				use_controller_to_login_as(@user3)
		  		params = { forum_user: { id: @user.id, banned: false } }
		  		patch '/forum_users', params 
			  	follow_redirect!
			  	@user = ForumUser.find(id)
		  		expect(@user.banned).to eq(false)
			end

			it "allows an administrator to change a user's username, email and password but cannot ban the user" do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank")
				id = @user.id
				use_controller_to_login_as(@user4)
		  		params = { forum_user: { id: @user.id, username: "hank", email: "hank@hank.com", password: "hank", banned: true } }
		  		patch '/forum_users', params 
			  	follow_redirect!
			  	@user = ForumUser.find(id)
		  		expect(@user.username).to eq("hank")
		  		expect(@user.email).to eq("hank@hank.com")
		  		expect(@user.banned).to eq(false)
		  		expect(@user.authenticate("frank")).to eq(false)
		  		expect(@user.authenticate("hank")).to eq(@user)
			end

			it "allows an ordinary user to change his or her own email and password but not username or banned status" do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank")
				id = @user.id
				params = {
		  			forum_user: { username: "frank", password: "frank" }
		  		}
		  		post '/login', params
		  		params = { forum_user: { id: @user.id, username: "hank", email: "hank@hank.com", password: "hank", banned: true } }
		  		patch '/forum_users', params 
			  	follow_redirect!
			  	@user = ForumUser.find(id)
		  		expect(@user.username).to eq("frank")
		  		expect(@user.email).to eq("hank@hank.com")
		  		expect(@user.banned).to eq(false)
		  		expect(@user.authenticate("frank")).to eq(false)
		  		expect(@user.authenticate("hank")).to eq(@user)
			end

			it "does not allow an ordinary user to change anything about another user" do 
				@user = ForumUser.create(username: "frank", email: "frank@frank.com", password: "frank")
				id = @user.id
				use_controller_to_login_as(@user2)
			  	follow_redirect!
			  	@user = ForumUser.find(id)
		  		params = { id: @user.id, forum_user: { username: "hank", email: "hank@hank.com", password: "hank", banned: true } }
		  		patch '/forum_users', params 
		  		expect(@user.username).to eq("frank")
		  		expect(@user.email).to eq("frank@frank.com")
		  		expect(@user.banned).to eq(false)
		  		expect(@user.authenticate("frank")).to eq(@user)
		  		expect(@user.authenticate("hank")).to eq(false)
			end

		end

	end

end