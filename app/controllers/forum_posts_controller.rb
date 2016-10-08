class ForumPostsController < Controller

	get '/forum_posts/new/:slug' do
		@thread = ForumThread.find_by_slug(:slug)
		erb :'/forum_posts/create'
	end

	post 'forum_posts' do
		@post = ForumPost.new
		set_attributes(@post, params[:forum_post], ["content", "forum_user_id", "forum_thread_id"])
		if @post.save
			route_array = params[:cached_route].split("/")
			redirect "/forum_threads/#{route_array.last}"
		else
			redirect "#{params[:cached_route]}"
		end
	end

	delete '/forum_posts' do
		if logged_in?
			@post = ForumThread.find(params[:forum_thread][:id])
			redirect "#{params[:cached_route]}" if @post.nil? || (@post.forum_user != current_user && !moderator?)
			@thread = @post.forum_thread
			@post.delete
			if @thread.posts.count == 0
				@thread.delete
				redirect '/threads'
			else
				redirect "#{params[:cached_route]}"
			end
		else
			redirect '/'
		end
	end

end