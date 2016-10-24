
def create_users(num_of_superusers, num_of_adminstrators, num_of_moderators, num_of_ordinary_users, num_of_banned_users, delay)

	user_array = []
	i = 1

	while i <= num_of_superusers + num_of_adminstrators + num_of_moderators + num_of_ordinary_users + num_of_banned_users do 
		if i <= num_of_superusers
			user_array << ForumUser.create(username: "lair00#{i}", email: "lair00#{i}@lair00#{i}.com", password: "lair00#{i}", moderator: true, administrator: true)
		elsif i <= num_of_superusers + num_of_adminstrators
			user_array << ForumUser.create(username: "lair00#{i}", email: "lair00#{i}@lair00#{i}.com", password: "lair00#{i}", administrator: true)
		elsif i <= num_of_superusers + num_of_adminstrators + num_of_moderators
			user_array << ForumUser.create(username: "lair00#{i}", email: "lair00#{i}@lair00#{i}.com", password: "lair00#{i}", moderator: true)
		elsif i <= num_of_superusers + num_of_adminstrators + num_of_moderators + num_of_ordinary_users
			user_array << ForumUser.create(username: "lair00#{i}", email: "lair00#{i}@lair00#{i}.com", password: "lair00#{i}")
		else
			user_array << ForumUser.create(username: "lair00#{i}", email: "lair00#{i}@lair00#{i}.com", password: "lair00#{i}", banned: true)
		end
		sleep delay
		i += 1
	end

	[user_array, delay]

end

def create_threads(users_delay_array, num_of_threads)

	thread_array = []
	i = 0

	while i < num_of_threads do 
		@user = users_delay_array[0][rand(1..users_delay_array[0].length)-1]
		thread_array << ForumThread.create(title: "Thread ##{i+1}")
		ForumPost.create(content: "Post ##{1} in Thread ##{i+1}", forum_user_id: @user.id, forum_thread_id: thread_array.last.id)
		sleep users_delay_array[1]
		i += 1
	end

	[users_delay_array[0], thread_array, users_delay_array[1]]

end

def create_posts(users_threads_delay_array, num_of_posts)

	i = 0

	while i < num_of_posts do 
		@user = users_threads_delay_array[0][rand(1..users_threads_delay_array[0].length)-1]
		@thread = users_threads_delay_array[1][rand(1..users_threads_delay_array[1].length)-1]
		ForumPost.create(content: "Post ##{@thread.forum_posts.count + 1} in Thread #{@thread.id}", forum_user_id: @user.id, forum_thread_id: @thread.id)
		sleep users_threads_delay_array[2]
		i += 1
	end

end

def seed_database(num_of_superusers, num_of_adminstrators, number_of_moderators, num_of_ordinary_users, num_of_banned_users, num_of_threads, num_of_posts, delay)
	create_posts(create_threads(create_users(num_of_superusers, num_of_adminstrators, number_of_moderators, num_of_ordinary_users, num_of_banned_users, delay), num_of_threads), num_of_posts)
end

seed_database(1, 1, 1, 5, 2, 20, 80, 2)