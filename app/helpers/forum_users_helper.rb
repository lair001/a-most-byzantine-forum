module ForumUsersHelper

	def logged_in?
		!!session[:forum_user_id]
	end

	def current_user
		@current_user ||= ForumUser.find(session[:forum_user_id])
	end

	def moderator?
		@moderator ||= current_user.moderator
	end

	def administrator?
		@administrator ||= current_user.administrator
	end

	def sort_users
		@users ||= ForumUser.order(username: :asc)
	end

end