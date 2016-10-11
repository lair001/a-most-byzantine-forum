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
			@user = ForumUser.find_by_slug(to_slug(params[:forum_user][:username]))
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
			redirect '/login'
		end
	end

	post '/forum_users' do 
		@user = ForumUser.new
		set_attributes(@user, params[:forum_user], ["username", "email", "password"])
		if @user.save
			session[:forum_user_id] = @user.id 
			redirect '/forum_threads'
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
			begin
				@user = ForumUser.find(params[:forum_user][:id])
			rescue ActiveRecord::RecordNotFound
				cached_route_or_home
			end
			settable_attr_array = []
			settable_attr_array << "banned" if moderator?
			administrator? ? settable_attr_array.push("username", "email", "password") : (settable_attr_array.push("email", "password") if @user == current_user)
			set_attributes(@user, params[:forum_user], settable_attr_array)
			if @user.save
				redirect '/forum_users'
			else
				cached_route_or_home
			end
		else
			redirect '/'
		end
	end

end