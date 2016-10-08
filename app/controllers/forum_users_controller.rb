class ForumUsersController < Controller

	get '/login' do
		if logged_in?
			redirect '/forum_threads'
		else
			erb :'forum_users/login'
		end
	end

	post '/login' do
		@user = ForumUser.find_by(username: params[:forum_user][:username])
		if @user && !@user.banned && @user.authenticate(params[:forum_user][:password])
			session[:forum_user_id] = @user.id
			redirect '/forum_threads'
		else
			redirect '/'
		end
	end

	get '/logout' do 
		if logged_in?
			session.clear
			redirect '/'
		else
			redirect '/'
		end
	end

	get '/forum_users' do 
		if logged_in?
			sort_users
			erb :'forum_users/index'
		else
			redirect '/'
		end
	end

	get '/forum_users/:slug' do 
		if logged_in?
			@user = ForumUser.find_by_slug(params[:slug])
			redirect '/threads' if @user.nil?
			sort_user_posts(@user)
			erb :'forum_users/show'
		else
			redirect '/'
		end
	end

end