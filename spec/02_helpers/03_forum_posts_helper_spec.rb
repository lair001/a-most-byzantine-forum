require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'ForumPostsHelper' do

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