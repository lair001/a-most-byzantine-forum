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

	delete '/forum_threads/:slug' do
		if moderator?
			@thread = ForumThread.find_by_slug(params[:slug])
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

end