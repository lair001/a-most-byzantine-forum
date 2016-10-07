class ForumThreadsController < Controller

	get '/fourum_threads' do 
		if logged_in
			erb :'forum_threads/forum_threads'
		else
			redirect '/'
		end
	end

end