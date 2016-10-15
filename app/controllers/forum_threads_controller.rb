class ForumThreadsController < Controller

	get '/forum_threads' do 
		if logged_in?
			sort_threads
			erb :'forum_threads/index'
		else
			redirect '/'
		end
	end

	get '/forum_threads/new' do 
		if logged_in?
			@thread = ForumThread.new
			@post = ForumPost.new
			erb :'forum_threads/create'
		else
			redirect '/'
		end
	end

	post '/forum_threads/search' do 
		if logged_in?
			@thread = ForumThread.find_by(trim_whitespace(params[:forum_thread], ["title"]))
			if @thread 
				redirect "/forum_threads/#{@thread.slug}"
			else
				redirect '/forum_threads?message=Title+not+found.'
			end
		else
			redirect '/'
		end
	end

	post '/forum_threads' do 
		if logged_in?
			@thread = ForumThread.new 
			set_attributes(@thread, trim_whitespace(params[:forum_thread], ["title"]), ["title"])
			if @thread.save
				@post = ForumPost.new 
				set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id"])
				@post.forum_thread = @thread 
				if @post.save 
					redirect "/forum_threads/#{@thread.slug}"
				else
					@current_route = "/forum_threads/new"
					@thread.delete
					erb :'forum_threads/create'
					# redirect '/forum_threads/new'
				end
			else
				@current_route = "/forum_threads/new"
				# grabbing any errors that the post may have
				@post = ForumPost.new
				set_attributes(@post, trim_whitespace(params[:forum_post], ["content"]), ["content", "forum_user_id"])
				@post.forum_thread = @thread
				@post.delete if @post.save
				erb :'forum_threads/create'
				# redirect '/forum_threads/new'
			end
		else
			redirect '/'
		end
	end

	get '/forum_threads/:slug' do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/forum_threads' if @thread.nil?
			sort_thread_posts
			erb :'forum_threads/show'
		else
			redirect '/'
		end
	end

	get '/forum_threads/:slug/edit' do 
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/forum_threads' if @thread.nil? || !moderator?
			erb :'forum_threads/edit'
		else
			redirect '/'
		end
	end

	delete '/forum_threads' do
		if moderator?
			begin
				@thread = ForumThread.find(params[:forum_thread][:id])
			rescue ActiveRecord::RecordNotFound
				redirect '/forum_threads'
			end
			if @thread.forum_posts
				@thread.forum_posts.each do |post|
					post.delete
				end
			end
			@thread.delete
			redirect '/forum_threads'
		else
			redirect '/'
		end
	end

	patch '/forum_threads' do
		if moderator?
			begin
				@thread = ForumThread.find(params[:forum_thread][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			set_attributes(@thread, trim_whitespace(params[:forum_thread], ["title"]), ["title"])
			if @thread.save
				redirect '/forum_threads'
			else
				@current_route = "/forum_threads/#{@thread.slug}/edit"
				erb :'forum_threads/edit'
				# cached_route_or_home
			end
		else
			redirect '/'
		end
	end

end