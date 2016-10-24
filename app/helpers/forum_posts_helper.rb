module ForumPostsHelper

	def sort_user_posts(user)
		@user_posts ||= user.forum_posts.order(updated_at: :desc)
	end

	def sort_thread_posts
		@thread_posts ||= @thread.forum_posts.order(created_at: :asc)
	end

end