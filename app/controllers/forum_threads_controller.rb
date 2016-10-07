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

end