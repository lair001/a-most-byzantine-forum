require 'sinatra_helper'
require 'controllers_spec_helper'

describe 'ForumUsersController' do

  before do
  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
  	@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
  	@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
  	@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
  	@user6 = ForumUser.create(username: "zack", email: "zack@zack.com", password: "zack", id: 6)

   	@thread1 = ForumThread.create(title: "the worst first", id: 1)
   	@thread5 = ForumThread.create(title: "The Great Schism", id: 5)

   	@post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1, id: 1)
   	@post2 = ForumPost.create(content: "Hal, do you want to be the first to be banned?", forum_user_id: 1, forum_thread_id: 1, id: 2)
  	@post10 = ForumPost.create(content: "I am the first to create an on topic thread.", forum_user_id: 4, forum_thread_id: 5, id: 10)
  end

  describe "get '/forum_threads/:slug/forum_posts/new'" do

  	it "redirects to / if not logged in" do
  		get "/forum_threads/#{@thread1.slug}/forum_posts/new"
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to /forum_threads if attempting to post to a non-existent thread while logged in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_threads/alexander-great/forum_posts/new"
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads")
  		expect(last_response.body).to include("Threads")
  	end

  	it "renders forum_posts/new if posting to an existent thread while logged in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_threads/#{@thread1.slug}/forum_posts/new"
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}/forum_posts/new")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Posting")
  	end

  end

  describe "get '/forum_posts/:id/edit'" do

  	it "redirects to / if not logged in" do 
  		get "/forum_posts/#{@post1.id}/edit"
  		expect_redirect
		expect(last_request.path).to eq("/")
		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to /forum_threads if attempting to edit a non-existent post while logged_in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_posts/#{@post1.id + 100}/edit"
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads")
  		expect(last_response.body).to include("Threads")
  	end

  	it "renders forum_posts/edit if editing an existent post while logged in as a moderator even if the post does not belong to the user" do 
  		use_controller_to_login_as(@user3)
  		get "/forum_posts/#{@post1.id}/edit"
    	expect(last_response.status).to eq(200)
    	expect(last_request.path).to eq("/forum_posts/#{@post1.id}/edit")
    	expect(last_response.body).to include("#{@post1.id}")
    	expect(last_response.body).to include("Editing")
  	end

  	it "renders forum_posts/edit if editing an existent post while logged in as an ordinary user if the post belongs to the user" do 
  		use_controller_to_login_as(@user2)
  		get "/forum_posts/#{@post1.id}/edit"
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_posts/#{@post1.id}/edit")
  		expect(last_response.body).to include("#{@post1.id}")
  		expect(last_response.body).to include("Editing")
  	end

  	it "redirects to /forum_threads if attempting to edit an existent post while logged in as an adminstrator without moderator powers if the post does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		get "/forum_posts/#{@post1.id}/edit"
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads")
  		expect(last_response.body).to include("Threads")
  	end

  end

  describe "post '/forum_posts" do 

  	it "redirects to '/' if not logged in" do 
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				content: "Please don't ban me!",
  				forum_user_id: "2",
  				forum_thread_id: "1"
  			}
  		}
  		post "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "renders forum_posts/create if logged in, a cached route is set, and the new post fails to save to the database" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				forum_user_id: "2",
  				forum_thread_id: "1"
  			}
  		}
  		post "/forum_posts", params
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_posts")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Posting")
  	end

  	it "renders forum_posts/new if logged in, no cached route is set, and the new post fails to save to the database" do
  		use_controller_to_login_as(@user2)
  		params = {
  			forum_post: {
  				forum_user_id: "2",
  				forum_thread_id: "1"
  			}
  		}
  		post "/forum_posts", params
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_posts")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Posting")
  	end

  	it "redirects to the show page of the new post's thread if logged in, a cached route is set, and the new post saves to the database" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				content: "Please don't ban me!",
  				forum_user_id: "2",
  				forum_thread_id: "1"
  			}
  		}
  		post "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Please don't ban me!")
  	end

  	it "redirects to /forum_threads if logged in, no cached route is set, and the new post saves to the database" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				content: "Please don't ban me!",
  				forum_user_id: "2",
  				forum_thread_id: "1"
  			}
  		}
  		post "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Please don't ban me!")
  	end

  end

  describe "patch '/forum_posts'" do 

  	it "redirects to '/' if not logged in" do 
  		params = {
  			cached_route: "/forum_posts/#{@post1.id}/edit",
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to cached route if logged in, a cached route is set, and attempting to edit a non-existent post" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_posts/#{@post1.id}/edit",
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id + 100}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_posts/#{@post1.id}/edit")
  		expect(last_response.body).to include("#{@post1.id}")
  		expect(last_response.body).to include("Editing")
  	end

  	it "redirects to / if logged in, no cached route is set, and attempting to edit a non-existent post" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id + 100}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to cached route if logged in as an ordinary user, a cached route is set, and attempting to edit a post that does not belong to the user" do 
  		use_controller_to_login_as(@user6)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
    	expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}/forum_posts/new")
    	expect(last_response.body).to include("#{@thread1.title}")
    	expect(last_response.body).to include("Posting")
  	end

  	it "redirects to / if logged in as an ordinary user, no cached route is set, and attempting to edit a post that does not belong to the user" do 
  		use_controller_to_login_as(@user6)
  		params = {
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to cached route if logged in as an adminstrator without moderator powers, a cached route is set, and attempting to edit a post that does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}/forum_posts/new",
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}/forum_posts/new")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Posting")
  	end

  	it "redirects to / if logged in as an adminstrator without moderator powers, no cached route is set, and attempting to edit a post that does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		params = {
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "renders forum_posts/edit if logged in, a cached route is provided, and the post fails to save to the database" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_posts/#{@post1.id}/edit",
  			forum_post: {
  				content: "I'm⥐sorry, please don't ban me.",
  				forum_user_id: "2",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_posts")
  		expect(last_response.body).to include("Edit")
  		expect(last_response.body).to include("#{@post1.id}")
  	end

  	it "forum_posts/edit if logged in, no cached route is provided, and the post fails to save to the database" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			forum_post: {
  				content: "I'm⥐sorry, please don't ban me.",
  				forum_user_id: "2",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect(last_response.status).to eq(200)
  		expect(last_request.path).to eq("/forum_posts")
  		expect(last_response.body).to include("Edit")
  		expect(last_response.body).to include("#{@post1.id}")
  	end

  	it "redirects to the show page of the edited post's thread if the post is successfully saved" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_posts/#{@post1.id}/edit",
  			forum_post: {
  				content: "I'm sorry, please don't ban me.",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("I'm sorry, please don't ban me.")
  	end

  	it "allows moderators to edit the posts of other users" do 
  		use_controller_to_login_as(@user3)
  		params = {
  			cached_route: "/forum_posts/#{@post1.id}/edit",
  			forum_post: {
  				content: "Sorry buddy, you're banned!",
  				forum_user_id: "2",
  				forum_thread_id: "1",
  				id: "#{@post1.id}"
  			}
  		}
  		patch "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("Sorry buddy, you're banned!")
  	end

  end

  describe "delete 'forum_posts'" do

  	it "redirects to '/' if not logged in" do 
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  		begin
  			@post = ForumPost.find(@post1.id)
  		rescue ActiveRecord::RecordNotFound
  			@post = nil
  		end
  		expect(@post.id).to eq(@post1.id)
  	end

  	it "redirects to cached route if logged in, a cached route is set, and attempting to delete a non-existent post" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id + 100}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("#{@post1.content}")
  	end

  	it "redirects to / if logged in, no cached route is set, and attempting to delete a non-existent post" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			forum_post: {
  				id: "#{@post1.id + 100}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
  	end

  	it "redirects to cached route if logged in as an ordinary user, a cached route is set, and attempting to delete a post that does not belong to the user" do 
  		use_controller_to_login_as(@user6)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("#{@post1.content}")
		begin
			@post = ForumPost.find(@post1.id)
		rescue ActiveRecord::RecordNotFound
			@post = nil
		end
		expect(@post.id).to eq(@post1.id)
  	end

  	it "redirects to / if logged in as an ordinary user, no cached route is set, and attempting to delete a post that does not belong to the user" do 
  		use_controller_to_login_as(@user6)
  		params = {
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
		begin
			@post = ForumPost.find(@post1.id)
		rescue ActiveRecord::RecordNotFound
			@post = nil
		end
		expect(@post.id).to eq(@post1.id)
  	end

  	it "redirects to cached route if logged in as an adminstrator without moderator powers, a cached route is set, and attempting to delete a post that does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).to include("#{@post1.content}")
  		begin
  			@post = ForumPost.find(@post1.id)
  		rescue ActiveRecord::RecordNotFound
  			@post = nil
  		end
  		expect(@post.id).to eq(@post1.id)
  	end

  	it "redirects to / if logged in as an adminstrator without moderator powers, no cached route is set, and attempting to delete a post that does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		params = {
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
		begin
			@post = ForumPost.find(@post1.id)
		rescue ActiveRecord::RecordNotFound
			@post = nil
		end
		expect(@post.id).to eq(@post1.id)
  	end

  	it "redirects to cached route if a cached routed is provided, the post is successfully deleted and the thread still has posts" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).not_to include("#{@post1.content}")
  		expect(last_response.body).to include("#{@post2.content}")
		begin
			@post = ForumPost.find(@post1.id)
		rescue ActiveRecord::RecordNotFound
			@post = nil
		end
		expect(@post).to be(nil)
  	end

  	it "redirects to / if no cached routed is provided, the post is successfully deleted and the thread still has posts" do 
  		use_controller_to_login_as(@user2)
  		params = {
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/")
  		expect(last_response.body).to include("Chat About All Things Roman")
		begin
			@post = ForumPost.find(@post1.id)
		rescue ActiveRecord::RecordNotFound
			@post = nil
		end
		expect(@post).to be(nil)
  	end

  	it "allows moderators to delete the posts of other users" do 
  		use_controller_to_login_as(@user3)
  		params = {
  			cached_route: "/forum_threads/#{@thread1.slug}",
  			forum_post: {
  				id: "#{@post1.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads/#{@thread1.slug}")
  		expect(last_response.body).to include("#{@thread1.title}")
  		expect(last_response.body).not_to include("#{@post1.content}")
  		expect(last_response.body).to include("#{@post2.content}")
  		begin
  			@post = ForumPost.find(@post1.id)
  		rescue ActiveRecord::RecordNotFound
  			@post = nil
  		end
  		expect(@post).to be(nil)
  	end

  	it "deletes a post's thread and redirects to /forum_threads if the last post of the thread is deleted" do 
  		use_controller_to_login_as(@user4)
  		params = {
  			forum_post: {
  				id: "#{@post10.id}"
  			}
  		}
  		delete "/forum_posts", params
  		expect_redirect
  		expect(last_request.path).to eq("/forum_threads")
  		expect(last_response.body).to include("Threads")
  		begin
  			@post = ForumPost.find(@post10.id)
  		rescue ActiveRecord::RecordNotFound
  			@post = nil
  		end
  		expect(@post).to be(nil)
  		begin
  			@thread = ForumThread.find(@thread5.id)
  		rescue ActiveRecord::RecordNotFound
  			@thread = nil
  		end
  		expect(@thread).to be(nil)
  	end

  end

end