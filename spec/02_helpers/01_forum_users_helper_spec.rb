require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'ForumUsersHelper' do

	before do
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
	  		helper.session = { forum_user_id: 1 }
	  		expect(helper.logged_in?).to eq(true)
	  	end

	  	it 'returns false if session[:forum_user_id] is not set' do
	  		helper.session = {}
	  		expect(helper.logged_in?).to eq(false)
	  	end

	end

	describe '#current_user' do

	  	it 'returns the current user' do
	  		helper.session = { forum_user_id: 2 }
	  		helper.current_user
	  		expect(helper.view_current_user.username).to eq("hal")
	  	end

	end

	describe '#moderator?' do

	  	it 'returns true if the current user is a moderator' do
	  		helper.session = { forum_user_id: 3 }
	  		helper.current_user
	  		expect(helper.moderator?).to eq(true)
	  	end

	  	it 'returns false if the current user is not a moderator' do
	  		helper.session = { forum_user_id: 2 }
	  		helper.current_user
	  		expect(helper.moderator?).to eq(false)
	  	end

	end

	describe '#administrator?' do

		it 'returns true if the current user is a administrator' do
	  		helper.session = { forum_user_id: 4 }
	  		helper.current_user
	  		expect(helper.administrator?).to eq(true)
		end

		it 'returns false if the current user is not administratator' do
			helper.session = { forum_user_id: 2 }
			helper.current_user
			expect(helper.administrator?).to eq(false)
  		end

	end

	describe '#sort_users' do

		it 'sorts users alphabetically' do
		helper.sort_users
		expect(helper.users).to eq(@user_array)
		end

	end

end