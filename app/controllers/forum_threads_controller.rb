class ForumThreadsController < Controller

	get '/forum_threads' do 
		if logged_in?
			erb :'forum_threads/forum_threads'
		else
			redirect '/'
		end
	end

end