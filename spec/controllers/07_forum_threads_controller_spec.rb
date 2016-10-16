require 'spec_helper'

describe 'ForumThreadsController' do 

	before do
		@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
		@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
		@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
		@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)

		@thread1 = ForumThread.create(title: "the worst first", id: 1)

		@post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
		@post2 = ForumPost.create(content: "Hal, do you want to be the first to be banned?", forum_user_id: 1, forum_thread_id: 1)
		@post3 = ForumPost.create(content: "You insult my honor, my lady.", forum_user_id: 2, forum_thread_id: 1)
		@post4 = ForumPost.create(content: "Let me do it!", forum_user_id: 3, forum_thread_id: 1)
		@post5 = ForumPost.create(content: "Wait, my hand slipped. I swear!", forum_user_id: 2, forum_thread_id: 1)
		@post6 = ForumPost.create(content: "I always wanted to change someone's username to Cthulhu.", forum_user_id: 4, forum_thread_id: 1)
		@post7 = ForumPost.create(content: "Fiddlesticks", forum_user_id: 2, forum_thread_id: 1)
	end

  	describe "get '/forum_threads'" do

  		it "redirects to / if not logged in" do
			get '/forum_threads'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "renders forum_threads/index view if logged in" do
			use_controller_to_login_as(@user1)
			get "/forum_threads"
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

  	end

  	describe "get '/forum_threads/new'" do

  		it "redirects to / if not logged in" do
			get '/forum_threads/new'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "renders forum_threads/new view if logged in" do
			use_controller_to_login_as(@user1)
			get "/forum_threads/new"
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_threads/new")
			expect(last_response.body).to include("Create")
			expect(last_response.body).to include("Thread")
		end

  	end

	describe "post '/forum_threads/search'" do

		it 'redirects to / if not logged in' do
			post '/forum_threads/search'
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to the thread's posts page if logged in and title is found" do
			use_controller_to_login_as(@user1)
			params = {
		  		forum_thread: { title: "#{@thread1.title}" }
		  	}
			post '/forum_threads/search', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
		  	expect(last_response.body).to include("#{@thread1.title}")
		end

		it "redirects to the /forum_users with message 'Title not found.' if logged in and title is not found" do
			use_controller_to_login_as(@user1)
			params = {
		  		forum_thread: { title: "Howdy Doo" }
		  	}
			post '/forum_threads/search', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		  	expect(last_response.body).to include("Title not found.")
		end

	end

	describe "get 'forum_threads/:slug'" do

		it "redirects to / if not logged in" do
			get "/forum_threads/#{@thread1.slug}"
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to /forum_threads if logged in and thread does not exist" do
			use_controller_to_login_as(@user1)
			get "/forum_threads/weasel-paradise"
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

		it "renders forum_threads/show if logged in and thread exists" do
			use_controller_to_login_as(@user1)
			get "/forum_threads/#{@thread1.slug}"
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
			expect(last_response.body).to include("#{@thread1.title}")
		end

	end

	describe "get 'forum_threads/:slug/edit'" do

		it "redirects to / if not logged in" do
			get "/forum_threads/#{@thread1.slug}/edit"
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to /forum_threads if logged in as an ordinary user" do
			use_controller_to_login_as(@user2)
			get "/forum_threads/#{@thread1.slug}/edit"
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

		it "redirects to /forum_threads if logged in as an administrator without moderator powers" do
			use_controller_to_login_as(@user4)
			get "/forum_threads/#{@thread1.slug}/edit"
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

		it "redirects to /forum_threads if logged in as a moderator and thread does not exist" do
			use_controller_to_login_as(@user3)
			get "/forum_threads/weasel-paradise"
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

		it "renders view forum_threads/edit if logged in as a moderator and thread exists" do
			use_controller_to_login_as(@user3)
			get "/forum_threads/#{@thread1.slug}/edit"
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}/edit")
			expect(last_response.body).to include("#{@thread1.title}")
			expect(last_response.body).to include("Edit")
		end

	end

	describe "post '/forum_threads'" do 
		it "redirects to / if not logged in" do
			params = {
				forum_thread: { title: "On Justinian" },
				forum_post: {content: "He should've conquered Persia instead.", forum_user_id: 2}
			}
			post "/forum_threads", params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "renders forum_threads/create without persisting a thread or a post if logged in and thread fails to save to database" do 
			use_controller_to_login_as(@user2)
			params = {
				forum_thread: { title: "" },
				forum_post: { content: "He should've conquered Persia instead.", forum_user_id: 2 }
			}
			post "/forum_threads", params
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Create")
			expect(last_response.body).to include("Thread")

			begin
				@thread = ForumThread.find_by(title: "")
			rescue ActiveRecord::RecordNotFound
				@thread = nil
			end
			expect(@thread).to be(nil)
			begin
				@post = ForumPost.find_by(content: "He should've conquered Persia instead.")
			rescue ActiveRecord::RecordNotFound
				@post = nil
			end
			expect(@post).to be(nil)
		end

		it "renders forum_threads/create without persisting a thread or a post if logged in and post fails to save to database" do 
			use_controller_to_login_as(@user2)
			params = {
				forum_thread: { title: "On Justinian" },
				forum_post: { content: "", forum_user_id: 2 }
			}
			post "/forum_threads", params
			expect(last_response.status).to eq(200)
			expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Create")
			expect(last_response.body).to include("Thread")

			begin
				@thread = ForumThread.find_by(title: "On Justinian")
			rescue ActiveRecord::RecordNotFound
				@thread = nil
			end
			expect(@thread).to be(nil)
			begin
				@post = ForumPost.find_by(content: "")
			rescue ActiveRecord::RecordNotFound
				@post = nil
			end
			expect(@post).to be(nil)
		end

		it "redirects to the new thread's show page if both the thread and its first post are successfully saved to the database" do 
			use_controller_to_login_as(@user2)
			params = {
				forum_thread: { title: "On Justinian" },
				forum_post: { content: "He should've conquered Persia instead.", forum_user_id: 2 }
			}
			post "/forum_threads", params
			expect_redirect

			begin
				@thread = ForumThread.find_by(title: "On Justinian")
			rescue ActiveRecord::RecordNotFound
				@thread = nil
			end
			begin
				@post = ForumPost.find_by(content: "He should've conquered Persia instead.")
			rescue ActiveRecord::RecordNotFound
				@post = nil
			end
			expect(@post.forum_thread_id).to eq(@thread.id)

			expect(last_request.path).to eq("/forum_threads/#{@thread.slug}")
			expect(last_response.body).to include("#{@thread.title}")
			expect(last_response.body).to include("#{@post.content}")
		end

	end

	describe "patch '/forum_threads'" do

		it "redirects to home if logged in as an ordinary user" do
			use_controller_to_login_as(@user2)
			params = {
				forum_thread: { title: "I'm sorry.", id: @thread1.id },
				cached_route: "/forum_threads/#{@thread1.slug}/edit"
			}
			patch '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to home if logged in as an administrator without moderator powers" do
			use_controller_to_login_as(@user4)
			params = {
				forum_thread: { title: "I'm sorry.", id: @thread1.id },
				cached_route: "/forum_threads/#{@thread1.slug}/edit"
			}
			patch '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to a cached route if a cached route is provided, logged in as a moderator, and attempting to edit a non-existent thread" do
			use_controller_to_login_as(@user3)
			params = {
				forum_thread: { title: "I'm sorry.", id: @thread1.id + 100 },
				cached_route: "/forum_threads/#{@thread1.slug}/edit"
			}
			patch '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}/edit")
			expect(last_response.body).to include("Edit")
			expect(last_response.body).to include("#{@thread1.title}")
		end

		it "redirects to / if no cached route is provided, logged in as a moderator, and attempting to edit a non-existent thread" do
			use_controller_to_login_as(@user3)
			params = {
				forum_thread: { title: "I'm sorry.", id: @thread1.id + 100 },
			}
			patch '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "renders forum_threads/edit if a cached route is provided, logged in as a moderator, and the thread fails to save to the database." do
			use_controller_to_login_as(@user3)
			params = {
				forum_thread: { title: "the\vworst\tfirst", id: @thread1.id },
				cached_route: "/forum_threads/#{@thread1.slug}/edit"
			}
			patch '/forum_threads', params
			expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Edit")
		end

		it "renders forum_threads/edit / if no cached route is provided, logged in as a moderator, and the thread fails to save to the database." do
			use_controller_to_login_as(@user3)
			params = {
				forum_thread: { title: "the\vworst\tfirst", id: @thread1.id  }
			}
			patch '/forum_threads', params
			expect(last_response.status).to eq(200)
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Edit")
		end

		it "redirects to a /forum_threads if logged in as a moderator and the thread successfully saves to the database." do
			use_controller_to_login_as(@user3)
			params = {
				forum_thread: { title: "He's sorry.", id: @thread1.id },
				cached_route: "/forum_threads"
			}
			patch '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

	end

	describe "delete '/forum_threads'" do

		it "redirects to home if logged in as an ordinary user" do
			use_controller_to_login_as(@user2)
			params = { forum_thread: { id: @thread1.id } }
			delete '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to home if logged in as an administrator without moderator powers" do
			use_controller_to_login_as(@user4)
			params = { forum_thread: { id: @thread1.id } }
			delete '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/")
			expect(last_response.body).to include("Chat About All Things Roman")
		end

		it "redirects to /forum_threads if logged in as a moderator and attempting to delete a non-existent thread" do
			use_controller_to_login_as(@user3)
			params = { forum_thread: { id: @thread1.id + 100 } }
			delete '/forum_threads', params
			expect_redirect
		  	expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

		it "deletes the thread and all posts in the thread and redirects to '/forum_threads' if logged in as a moderator and deleting an existing thread" do 
			use_controller_to_login_as(@user3)
			params = { forum_thread: { id: @thread1.id } }
			delete '/forum_threads', params
			expect_redirect
			expect(last_request.path).to eq("/forum_threads")
			expect(last_response.body).to include("Threads")
			begin
				@thread = ForumThread.find_by(title: "#{@thread1.title}")
			rescue ActiveRecord::RecordNotFound
				@thread = nil
			end
			expect(@thread).to be(nil)
			begin
				@post = ForumPost.find_by(forum_thread_id: "#{@thread1.id}")
			rescue ActiveRecord::RecordNotFound
				@post = nil
			end
			expect(@post).to be(nil)
		end

	end

end