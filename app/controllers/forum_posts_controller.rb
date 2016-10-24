class ForumPostsController < Controller

	get '/forum_posts/new/:slug' do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/forum_threads' if @thread.nil?
			@post = ForumPost.new
			erb :'forum_posts/new.html'
		else
			redirect '/'
		end
	end

	get '/forum_posts/:id/edit' do 
		if logged_in?
			begin
				@post = ForumPost.find(params[:id])
			rescue ActiveRecord::RecordNotFound
				redirect '/forum_threads'
			end
			if moderator? || @post.forum_user == current_user
				erb :'forum_posts/edit.html'
			else
				redirect '/forum_threads'
			end
		else
			redirect '/'
		end
	end

	post '/forum_posts' do
		if logged_in?
			@post = ForumPost.new
			if set_and_save_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id", "forum_thread_id"])
				if params[:cached_route]
					route_array = params[:cached_route].split("/")
					redirect "/forum_threads/#{route_array.last}"
				else
					redirect "/forum_threads"
				end
			else
				@current_route = "/forum_posts/new"
				@thread = ForumThread.find(params[:forum_post][:forum_thread_id])
				erb :'forum_posts/new.html'
				# cached_route_or_home
			end
		else
			redirect '/'
		end
	end

	patch '/forum_posts' do 
		if logged_in?
			begin
				@post = ForumPost.find(params[:forum_post][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			cached_route_or_home if @post.forum_user != current_user && !moderator?
			params["forum_post"]["current_user"] = current_user
			if set_and_save_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "current_user"])
				redirect "/forum_threads/#{@post.forum_thread.slug}"
			else
				@current_route = "/forum_posts/#{@post.id}/edit"
				erb :'forum_posts/edit.html'
				# cached_route_or_home
			end
		else
			redirect '/'
		end
	end

	delete '/forum_posts' do
		if logged_in?
			begin
				@post = ForumPost.find(params[:forum_post][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			cached_route_or_home if @post.forum_user != current_user && !moderator?
			@thread = @post.forum_thread
			@post.delete
			current_user.update(last_active: Time.now)
			if @thread.forum_posts.count == 0
				@thread.delete
				redirect '/forum_threads'
			else
				cached_route_or_home
			end
		else
			redirect '/'
		end
	end

end