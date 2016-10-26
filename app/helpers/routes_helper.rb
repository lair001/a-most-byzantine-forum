module RoutesHelper

	def current_route
		@current_route ||= request.path_info
	end

	def cached_route_or_home
		params[:cached_route].nil? ? redirect(root_path) : redirect("#{params[:cached_route]}")
	end

	def login_path
		"/login"
	end

	def root_path
		"/"
	end

	def tribute_path
		"/C11P"
	end

	def edit_forum_thread_forum_post_path(thread=nil, post=nil)
		if thread && post
			"/forum_threads/#{thread.slug}/forum_posts/#{post.slug}"
		else
			"/forum_threads/:forum_thread_slug/forum_posts/:slug"
		end
	end

end