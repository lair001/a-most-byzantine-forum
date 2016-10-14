class ForumPostsController < Controller

	get '/forum_posts/new/:slug' do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/forum_threads' if @thread.nil?
			erb :'forum_posts/create'
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
				erb :'forum_posts/edit'
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
			set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id", "forum_thread_id"])
			if @post.save
				if params[:cached_route]
					route_array = params[:cached_route].split("/")
					redirect "/forum_threads/#{route_array.last}"
				else
					redirect "/forum_threads"
				end
			else
				cached_route_or_home
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
			set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content"])
			if @post.save
				redirect "/forum_threads/#{@post.forum_thread.slug}"
			else
				cached_route_or_home
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