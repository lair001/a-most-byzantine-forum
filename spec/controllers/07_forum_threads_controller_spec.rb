require 'spec_helper'

describe 'ForumThreadsController' do 

	before do
		@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
		@thread1 = ForumThread.create(title: "the worst first", id: 1)
	end

  	describe "get '/forum_threads'" do 

  		it "redirects to / if not logged in" do
			get '/forum_threads'
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/")
			expect(last_response.body).to include("A Most Byzantine Forum")
		end

		it "renders forum_threads/index view if logged in" do
			use_controller_to_login_as(@user1)
			get "/forum_threads"
			expect(last_response.status).to eq(200)
			expect(last_request.path).to include("/forum_threads")
			expect(last_response.body).to include("Threads")
		end

  	end

  	describe "get '/forum_threads/new'" do 

  		it "redirects to / if not logged in" do
			get '/forum_threads/new'
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/")
			expect(last_response.body).to include("A Most Byzantine Forum")
		end

		it "renders forum_threads/new view if logged in" do
			use_controller_to_login_as(@user1)
			get "/forum_threads/new"
			expect(last_response.status).to eq(200)
			expect(last_request.path).to include("/forum_threads/new")
			expect(last_response.body).to include("Create")
			expect(last_response.body).to include("Thread")
		end

  	end

	describe "post '/forum_threads/search'" do

		it 'redirects to / if not logged in' do 
			post '/forum_threads/search'
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/")
			expect(last_response.body).to include("A Most Byzantine Forum")
		end

		it "redirects to the thread's posts page if logged in and title is found" do
			use_controller_to_login_as(@user1)
			params = {
		  		forum_thread: { title: "#{@thread1.title}" }
		  	}
			post '/forum_threads/search', params 
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_threads/#{@thread1.slug}")
		  	expect(last_response.body).to include("#{@thread1.title}")
		end

		it "redirects to the /forum_users with message 'Title not found.' if logged in and title is not found" do
			use_controller_to_login_as(@user1)
			params = {
		  		forum_thread: { title: "Howdy Doo" }
		  	}
			post '/forum_threads/search', params 
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_threads")
		  	expect(last_response.body).to include("Threads")
		  	expect(last_response.body).to include("Title not found.")
		end

	end

end