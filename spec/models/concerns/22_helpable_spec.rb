require 'spec_helper'

describe 'Helpable' do 

	before do
	  	@helper1 = Helper.new
		@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
	  	@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
	  	@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
	  	@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)

	  	@thread1 = ForumThread.create(title: "the worst first", id: 1)
	  	@thread2 = ForumThread.create(title: "Michael Jackson is a very bad boy", id: 2)
	  	@thread3 = ForumThread.create(title: "The Lion, the Witch, and Madeline Albright", id: 3)
	  	@thread4 = ForumThread.create(title: "Hello and Goodbye, Phil", id: 4)

	  	@post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
	  	@post2 = ForumPost.create(content: "Hal, do you want to be the first to be banned?", forum_user_id: 1, forum_thread_id: 1)
	  	@post3 = ForumPost.create(content: "You insult my honor, my lady.", forum_user_id: 2, forum_thread_id: 1)
	  	@post4 = ForumPost.create(content: "Let me do it!", forum_user_id: 3, forum_thread_id: 1)
		@post5 = ForumPost.create(content: "Wait, my hand slipped. I swear!", forum_user_id: 2, forum_thread_id: 1)
		@post6 = ForumPost.create(content: "I always wanted to change someone's username to Cthulhu.", forum_user_id: 4, forum_thread_id: 1)
		@post7 = ForumPost.create(content: "Fiddlesticks", forum_user_id: 2, forum_thread_id: 1)

		@user_array = ForumUser.all.sort { |a, b| a.username <=> b.username }
		@user2_posts_array = @user2.forum_posts.sort { |a, b| b.updated_at <=> a.updated_at }

	  	@thread_array = ForumThread.all.sort { |a, b| b.updated_at <=> a.updated_at }
	  	@thread1_posts_array = @thread1.forum_posts.sort { |a, b| a.created_at <=> b.created_at }
	end

	describe '#logged in' do 

	  	it 'returns true if session[:forum_user_id] is set' do 
	  		@helper1.session = { forum_user_id: 1 }
	  		expect(@helper1.logged_in?).to eq(true)
	  	end

	  	it 'returns false if session[:forum_user_id] is not set' do 
	  		@helper1.session = {}
	  		expect(@helper1.logged_in?).to eq(false)
	  	end

	end

	describe '#current_user' do 

	  	it 'returns the current user' do 
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.view_current_user.username).to eq("hal")
	  	end

	end

	describe '#moderator' do 

	  	it 'returns true if the current user is a moderator' do
	  		@helper1.session = { forum_user_id: 3 }
	  		@helper1.current_user
	  		expect(@helper1.moderator?).to eq(true)
	  	end

	  	it 'returns false if the current user is not a moderator' do
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.moderator?).to eq(false)
	  	end

	end

	describe '#administrator' do 

  		it 'returns true if the current user is a administrator' do
	  		@helper1.session = { forum_user_id: 4 }
	  		@helper1.current_user
	  		expect(@helper1.administrator?).to eq(true)
  		end

  		it 'returns false if the current user is not administratator' do
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.administrator?).to eq(false)
	  	end

  	end

  	describe '#current_route' do 

  		it 'returns the current route' do 
  			@helper1.request.path_info = '/'
  			expect(@helper1.current_route).to eq('/')
  		end

  	end

  	describe '#format_time' do 

  		it 'formats Time objects' do 
  			@time1 = Time.new(2011, 11, 11, 11, 11, 11, "+00:00")
  			expect(@helper1.format_time(@time1)).to eq("2011/11/11 11:11:11")
  		end

  	end

	describe '#to_slug' do 

  		it 'slugifies strings and sets the result to @slug if @slug is not already set' do 
  			expect(@helper1.to_slug("The Great")).to eq("the-great")
  			expect(@helper1.to_slug("The-worst First")).to eq("the-great")
  			@helper1.slug = nil
  			expect(@helper1.to_slug("The-worst First")).to eq("the-worst-first")
  		end

  	end

  	describe '#cached_route_or_home' do 

  		it 'redirects to a cached path if set or home if there is no cached path' do 
  			expect(@helper1.cached_route_or_home).to eq('/')
  			@helper1.params[:cached_route] = '/threads'
  			expect(@helper1.cached_route_or_home).to eq('/threads')
  		end

  	end

  	describe '#set_attributes' do 

  		it 'it sets attributes of an object that are permitted to be set using values in a hash' do 
  			@user5 = ForumUser.create(username: "phil", email: "phil@phil.com", password: "phil", moderator: true, administrator: true, id: 5)
  			attr_hash = { username: "bill", email: "bill@bill.com", password: "bill", banned: true }
  			settable_attr_array = ["username", "email", "password"]
  			@helper1.set_attributes(@user1, attr_hash, settable_attr_array)
  			expect(@user1.username).to eq("bill")
  			expect(@user1.email).to eq("bill@bill.com")
  			expect(@user1.password).to eq("bill")
  			expect(@user1.banned).to eq(false)
  			attr_hash = { username: "will", email: "will@will.com", password: "will", banned: true }
  			settable_attr_array = [:email, :password, :banned]
  			@helper1.set_attributes(@user1, attr_hash, settable_attr_array)
  			expect(@user1.username).to eq("bill")
  			expect(@user1.email).to eq("will@will.com")
  			expect(@user1.password).to eq("will")
  			expect(@user1.banned).to eq(true)
  		end

  	end

  	describe '#sort_users' do 

  		it 'sorts users alphabetically' do 
			@helper1.sort_users
			expect(@helper1.users).to eq(@user_array)
  		end

  	end

  	describe '#sort_threads' do 

  		it 'sorts threads based on time when last updated (recently updated threads come first)' do 
			@helper1.sort_threads
			expect(@helper1.threads).to eq(@thread_array)
  		end

  	end

  	describe '#sort_user_posts' do 

  		it "sorts a user's posts based on time when last updated (recently updated threads come first)" do 
			@helper1.sort_user_posts(@user2)
			expect(@helper1.user_posts).to eq(@user2_posts_array)
  		end

  	end

  	describe '#sort_thread_posts' do 

  		it "sorts a user's posts based on time when last updated (recently updated threads come first)" do 
  			@helper1.thread = @thread1
			@helper1.sort_thread_posts
			expect(@helper1.thread_posts).to eq(@thread1_posts_array)
  		end

  	end

end