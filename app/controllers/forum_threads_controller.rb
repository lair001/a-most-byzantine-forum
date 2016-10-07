class ForumThreadsController < Controller

	get '/forum_threads' do 
		if logged_in?
			sort_threads
			erb :'forum_threads/forum_threads'
		else
			redirect '/'
		end
	end

end