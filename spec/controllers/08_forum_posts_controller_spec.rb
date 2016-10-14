require 'spec_helper'

describe 'ForumUsersController' do

  before do
	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
	@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
	@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
	@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
 	@thread1 = ForumThread.create(title: "the worst first", id: 1)
 	@post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
  end

  describe "get '/forum_posts/new/:slug'" do

  	it "redirects to / if not logged in" do
  		get "/forum_posts/new/#{@thread1.slug}"
  		expect(last_response.status).to eq(302)
		follow_redirect!
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/")
		expect(last_response.body).to include("A Most Byzantine Forum")
  	end

  	it "redirects to /forum_threads if attempting to post to a non-existent thread while logged in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_posts/new/alexander-great"
  		expect(last_response.status).to eq(302)
		follow_redirect!
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_threads")
		expect(last_response.body).to include("Threads")
  	end

  	it "renders forum_posts/create if posting to an existent thread while logged in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_posts/new/#{@thread1.slug}"
  		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_posts/new/#{@thread1.slug}")
		expect(last_response.body).to include("#{@thread1.title}")
		expect(last_response.body).to include("Posting")
  	end

  end

  describe "get '/forum_posts/:id/edit'" do

  	it "redirects to / if not logged in" do 
  		get "/forum_posts/#{@post1.id}/edit"
  		expect(last_response.status).to eq(302)
		follow_redirect!
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/")
		expect(last_response.body).to include("A Most Byzantine Forum")
  	end

  	it "redirects to /forum_threads if attempting to edit a non-existent post while logged_in" do 
  		use_controller_to_login_as(@user1)
  		get "/forum_posts/#{@post1.id + 1}/edit"
  		expect(last_response.status).to eq(302)
		follow_redirect!
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_threads")
		expect(last_response.body).to include("Threads")
  	end

  	it "renders forum_posts/edit if editing an existent post while logged in as a moderator even if the post does not belong to the user" do 
  		use_controller_to_login_as(@user3)
  		get "/forum_posts/#{@post1.id}/edit"
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_posts/#{@post1.id}/edit")
		expect(last_response.body).to include("#{@post1.id}")
		expect(last_response.body).to include("Editing")
  	end

  	it "renders forum_posts/edit if editing an existent post while logged in as an ordinary user if the post belongs to the user" do 
  		use_controller_to_login_as(@user2)
  		get "/forum_posts/#{@post1.id}/edit"
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_posts/#{@post1.id}/edit")
		expect(last_response.body).to include("#{@post1.id}")
		expect(last_response.body).to include("Editing")
  	end

  	it "redirects to /forum_threads if attempting to edit an existent post while logged in as an adminstrator without moderator powers if the post does not belong to the user" do 
  		use_controller_to_login_as(@user4)
  		get "/forum_posts/#{@post1.id}/edit"
  		expect(last_response.status).to eq(302)
		follow_redirect!
		expect(last_response.status).to eq(200)
		expect(last_request.path).to include("/forum_threads")
		expect(last_response.body).to include("Threads")
  	end


  end

end