module Helpable

	def logged_in?
		!!session[:user_id]
	end

	def current_user
		@current_user ||= ForumUser.find(session[:user_id])
	end

	def moderator?
		@moderator ||= current_user.moderator
	end

	def administrator?
		@administrator ||= current_user.administrator
	end

	def current_route
		@current_route ||= request.path_info
	end

	def sort_threads
		@threads ||= Threads.order(updated_at: :desc)
	end

	def sort_posts
		@posts ||= @thread.posts.order(created_at: :asc)
	end

end