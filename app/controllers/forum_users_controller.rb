class ForumUsersController < Controller

	get '/login' do
		if logged_in?
			redirect '/forum_threads'
		else
			erb :'forum_users/login'
		end
	end

	get '/forum_users/new' do 
		if logged_in?
			redirect '/forum_threads'
		else
			erb :'forum_users/create'
		end
	end

	post '/forum_users/search' do 
		if logged_in?
			@user = ForumUser.find_by_slug(to_slug(params[:username]))
			if @user 
				redirect "/forum_users/#{@slug}"
			else
				redirect '/forum_users?message=Username+not+found.'
			end
		else
			redirect '/'
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

	post '/users' do 
		@user = ForumUser.new
		set_attributes(@user, params[:forum_user], ["username", "email", "password"])
		if ForumUser.validate_by_slug(@user)
			if @user.save
				session[:forum_user_id] = @user.id 
				redirect '/forum_threads'
			else
				redirect '/forum_users/new'
			end
		else
			redirect '/forum_users/new'
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

	get '/forum_users/:slug/edit' do 
		if logged_in?
			@user = ForumUser.find_by_slug(params[:slug])
			if administrator? || (@user && @user == current_user)
				erb :'forum_users/edit'
			else
				redirect '/'
			end
		else
			redirect '/'
		end
	end

	patch '/forum_users' do
		if logged_in?
			@user = ForumUser.find(params[:forum_user][:id])
			redirect "#{params[:cached_route]}" if @user.nil?
			settable_attr_array = []
			settable_attr_array << "banned" if moderator?
			if administrator?
				settable_attr_array << "username"
				settable_attr_array << "email"
				settable_attr_array << "password"
			elsif @user == current_user
				settable_attr_array << "email"
				settable_attr_array << "password"
			end
			set_attributes(@user, params[:forum_user], settable_attr_array)
			if @user.save
				redirect '/forum_users'
			else
				redirect "#{params[:cached_route]}"
			end
		else
			redirect '/'
		end
	end

end