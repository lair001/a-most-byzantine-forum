class ForumPostsController < Controller


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