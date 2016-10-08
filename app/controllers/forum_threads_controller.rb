class ForumThreadsController < Controller

	get '/forum_threads' do 
		if logged_in?
			sort_threads
			erb :'forum_threads/index'
		else
			redirect '/'
		end
	end

	get '/forum_threads/:slug' do
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/threads' if @thread.nil?
			sort_thread_posts
			erb :'forum_threads/show'
		else
			redirect '/'
		end
	end

	get '/forum_threads/:slug/edit' do 
		if logged_in?
			@thread = ForumThread.find_by_slug(params[:slug])
			redirect '/threads' if @thread.nil?
			erb :'forum_threads/edit'
		else
			redirect '/'
		end
	end

	delete '/forum_threads' do
		if moderator?
			@thread = ForumThread.find(params[:forum_thread][:id])
			redirect '/threads' if @thread.nil?
			@thread.posts.each do |post|
				post.delete
			end
			@thread.delete
			redirect '/threads'
		else
			redirect '/'
		end
	end

	patch '/forum_threads' do
		if moderator?
			@thread = ForumThread.find(params[:forum_thread][:id])
			redirect "#{params[:cached_route]}" if @thread.nil?
			set_attributes(@thread, params[:forum_thread], ["title"])
			if @thread.save
				redirect '/threads'
			else
				redirect "#{params[:cached_route]}"
			end
		else
			redirect '/'
		end
	end

end