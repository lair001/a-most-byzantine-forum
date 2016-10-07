class ForumUsersController < Controller

	get '/login' do
		if logged_in?
			redirect '/forum_threads'
		else
			erb :'forum_users/login'
		end
	end

	post '/login' do
		@user = ForumUser.find_by(username: params[:username])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
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

end