require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'ApplicationHelper' do

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

	describe '#format_time' do

		it 'formats Time objects' do
			@time1 = Time.new(2011, 11, 11, 11, 11, 11, "+00:00")
			expect(helper.format_time(@time1)).to eq("2011/11/11 11:11:11")
		end

	end

	describe '#set_attributes' do

		it 'it sets attributes of an object that are permitted to be set using values in a hash' do 
			@user5 = ForumUser.create(username: "phil", email: "phil@phil.com", password: "phil", moderator: true, administrator: true, id: 5)
			attr_hash = { username: "bill", email: "bill@bill.com", password: "bill", banned: true }
			settable_attr_array = ["username", "email", "password"]
			helper.set_attributes(@user5, attr_hash, settable_attr_array)
			expect(@user5.username).to eq("bill")
			expect(@user5.email).to eq("bill@bill.com")
			expect(@user5.password).to eq("bill")
			expect(@user5.banned).to eq(false)
			attr_hash = { username: "will", email: "will@will.com", password: "will", banned: true }
			settable_attr_array = [:email, :password, :banned]
			helper.set_attributes(@user5, attr_hash, settable_attr_array)
			expect(@user5.username).to eq("bill")
			expect(@user5.email).to eq("will@will.com")
			expect(@user5.password).to eq("will")
			expect(@user5.banned).to eq(true)
		end

	end

	describe "#set_and_save_attributes" do

		it "it sets attributes of an object that are permitted to be set using values in a hash and then persists the altered object to the database" do
			@user5 = ForumUser.create(username: "phil", email: "phil@phil.com", password: "phil", moderator: true, administrator: true, id: 5)
			attr_hash = { username: "bill", email: "bill@bill.com", password: "bill", banned: true }
			settable_attr_array = ["username", "email", "password"]
			helper.set_and_save_attributes(@user5, attr_hash, settable_attr_array)
			expect(@user5.username).to eq("bill")
			expect(@user5.email).to eq("bill@bill.com")
			expect(@user5.password).to eq("bill")
			expect(@user5.banned).to eq(false)
			@user6 = ForumUser.find_by(username: "bill")
			expect(@user6.id).to eq(@user5.id)
		end

	end

	describe '#trim_whitespace' do

		it 'trims whitespace in hash key values where the hash key is included in an array' do 
			params = { content: " A \t great \n\t time \nnow,\r then.\n", title: "  A  Great \t Time", password: " \tabc  dd \r c" }
			params = helper.trim_whitespace(params, [:content, :title])
			expect(params[:content]).to eq("A\tgreat\n\ttime\nnow,\rthen.")
			expect(params[:title]).to eq("A Great\tTime")
			expect(params[:password]).to eq(" \tabc  dd \r c")

			params = { "content" => " A \t great \n\t time \nnow,\r then.\n", "title" => "  A  Great \t Time", "password" => " \tabc  dd \r c" }
			params = helper.trim_whitespace(params, ["content", "title"])
			expect(params["content"]).to eq("A\tgreat\n\ttime\nnow,\rthen.")
			expect(params["title"]).to eq("A Great\tTime")
			expect(params["password"]).to eq(" \tabc  dd \r c")
		end

	end

	describe 'whitespace_as_html' do

		it 'converts whitespace into html entities' do
			expect(helper.whitespace_as_html("ipsum|\t|\u2003|\r\n|\f|\n|\r|\v|lorem")).to eq("ipsum|&emsp;&emsp;|&emsp;|<br>|<br>|<br>|<br>|<br><br>|lorem")
		end

	end

end