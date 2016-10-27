class ForumThreadsController < Controller

	get forum_threads_path do 
		if logged_in?
			sort_threads
			erb :'forum_threads/index.html'
		else
			redirect root_path
		end
	end

	get new_forum_thread_path do 
		if logged_in?
			@thread = ForumThread.new
			@post = ForumPost.new
			erb :'forum_threads/new.html'
		else
			redirect root_path
		end
	end

	post search_forum_threads_path do 
		if logged_in?
			@thread = ForumThread.find_by(trim_whitespace(params[:forum_thread], ["title"]))
			current_user.update(last_active: Time.now)
			if @thread 
				redirect forum_thread_path(@thread)
			else
				redirect "#{forum_threads_path}?message=Title+not+found."
			end
		else
			redirect root_path
		end
	end

	# post '/forum_threads' do 
	# 	if logged_in?
	# 		@thread = ForumThread.new
	# 		if set_and_save_attributes(@thread, trim_whitespace(params[:forum_thread], ["title"]), ["title"])
	# 			@post = ForumPost.new 
	# 			set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id"])
	# 			@post.forum_thread = @thread 
	# 			if @post.save 
	# 				redirect "/forum_threads/#{@thread.slug}"
	# 			else
	# 				@current_route = "/forum_threads/new"
	# 				@thread.delete
	# 				erb :'forum_threads/new.html'
	# 				# redirect '/forum_threads/new'
	# 			end
	# 		else
	# 			@current_route = "/forum_threads/new"
	# 			# grabbing any errors that the post may have
	# 			@post = ForumPost.new
	# 			set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id"])
	# 			@post.forum_thread = @thread
	# 			@post.delete if @post.save
	# 			erb :'forum_threads/new.html'
	# 			# redirect '/forum_threads/new'
	# 		end
	# 	else
	# 		redirect root_path
	# 	end
	# end

	post forum_threads_path do 
		if logged_in?
			@thread = ForumThread.new
			params["forum_thread"]["forum_post_attributes"] = trim_whitespace(params["forum_thread"]["forum_post_attributes"], ["content"])
			if set_and_save_attributes(@thread, trim_whitespace(params[:forum_thread], ["title"]), ["title", "forum_post_attributes"])
				redirect forum_thread_path(@thread)
			else
				@current_route = new_forum_thread_path
				@thread.errors.delete(:forum_posts)
				erb :'forum_threads/new.html'
				# redirect '/forum_threads/new'
			end
		else
			redirect root_path
		end
	end

	get forum_thread_path do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect forum_threads_path if @thread.nil?
			sort_thread_posts
			erb :'forum_threads/show.html'
		else
			redirect root_path
		end
	end

	get edit_forum_thread_path do 
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect forum_threads_path if @thread.nil? || !moderator?
			erb :'forum_threads/edit.html'
		else
			redirect root_path
		end
	end

	delete forum_threads_path do
		if moderator?
			begin
				@thread = ForumThread.find(params[:forum_thread][:id])
			rescue ActiveRecord::RecordNotFound
				redirect forum_threads_path
			end
			@thread.forum_posts.delete_all
			tell_model_about_current_user_and_destroy(@thread)
			redirect forum_threads_path
		else
			redirect root_path
		end
	end

	patch forum_threads_path do
		if moderator?
			begin
				@thread = ForumThread.find(params[:forum_thread][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			params["forum_thread"]["current_user"] = current_user
			if set_and_save_attributes(@thread, trim_whitespace(params[:forum_thread], ["title"]), ["title", "current_user"])
				redirect forum_threads_path
			else
				@current_route = edit_forum_thread_path(@thread)
				erb :'forum_threads/edit.html'
				# cached_route_or_home
			end
		else
			redirect root_path
		end
	end

end