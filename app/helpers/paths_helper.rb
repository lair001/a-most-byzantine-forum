module PathsHelper

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
			"/forum_threads/#{thread.slug}/forum_posts/#{post.slug}/edit"
		else
			"/forum_threads/:forum_thread_slug/forum_posts/:slug/edit"
		end
	end

end