module PathsHelper

	module ForumUsers

		def forum_users_path
			"/forum_users"
		end

		def forum_user_path(user=nil)
			"#{forum_users_path}/#{user ? user.slug : ":slug"}"
		end

		def edit_forum_user_path(user=nil)
			"#{forum_user_path(user)}/edit"
		end

		def new_forum_user_path
			"#{forum_users_path}/new"
		end

		def search_forum_users_path
			"#{forum_users_path}/search"
		end

	end

end