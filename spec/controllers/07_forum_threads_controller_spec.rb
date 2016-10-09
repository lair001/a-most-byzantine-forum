require 'spec_helper'

describe 'ForumThreadsController' do 

  before do
  	@user = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true)
  	@thread = ForumThread.create(title: "The Great")
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
			params = {
		  		forum_user: { username: "val", password: "val" },
		  		forum_thread: { title: "The Great" }
		  	}
		  	post '/login', params
			post '/forum_threads/search', params 
			expect(last_response.status).to eq(302)
		  	follow_redirect!
		  	expect(last_response.status).to eq(200)
		  	expect(last_request.path).to include("/forum_threads/the-great")
		  	expect(last_response.body).to include("The Great")
		end

		it "redirects to the /forum_users with message 'Title not found.' if logged in and title is not found" do
			params = {
		  		forum_user: { username: "val", password: "val" },
		  		forum_thread: { title: "Howdy Doo" }
		  	}
		  	post '/login', params
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