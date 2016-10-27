class ForumPostsController < Controller

	get new_forum_thread_forum_post_path do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:forum_thread_slug])
			redirect forum_threads_path if @thread.nil?
			@post = ForumPost.new
			erb :'forum_posts/new.html'
		else
			redirect root_path
		end
	end

	get edit_forum_thread_forum_post_path do 
		if logged_in?
			@post = ForumPost.find_by_slug(params[:slug])
			redirect forum_threads_path if @post.nil?
			if moderator? || @post.forum_user == current_user
				erb :'forum_posts/edit.html'
			else
				redirect forum_threads_path
			end
		else
			redirect root_path
		end
	end

	post forum_posts_path do
		if logged_in?
			@post = ForumPost.new
			if set_and_save_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id", "forum_thread_id"])
				if params[:cached_route]
					route_array = params[:cached_route].split("/")
					redirect "#{forum_threads_path}/#{route_array[2]}"
				else
					redirect forum_threads_path
				end
			else
				@current_route = new_forum_post_path
				@thread = ForumThread.find(params[:forum_post][:forum_thread_id])
				erb :'forum_posts/new.html'
				# cached_route_or_home
			end
		else
			redirect root_path
		end
	end

	patch forum_posts_path do 
		if logged_in?
			begin
				@post = ForumPost.find(params[:forum_post][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			cached_route_or_home if @post.forum_user != current_user && !moderator?
			params["forum_post"]["current_user"] = current_user
			if set_and_save_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "current_user"])
				redirect forum_thread_path(@post.forum_thread)
			else
				@current_route = edit_forum_post_path
				erb :'forum_posts/edit.html'
				# cached_route_or_home
			end
		else
			redirect root_path
		end
	end

	delete forum_posts_path do
		if logged_in?
			begin
				@post = ForumPost.find(params[:forum_post][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			cached_route_or_home if @post.forum_user != current_user && !moderator?
			@thread = @post.forum_thread
			tell_model_about_current_user_and_destroy(@post)
			if @thread.forum_posts.count == 0
				@thread.delete
				redirect forum_threads_path
			else
				cached_route_or_home
			end
		else
			redirect root_path
		end
	end

end