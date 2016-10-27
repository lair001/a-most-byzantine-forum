class SessionsController < Controller

	get login_path do
		if logged_in?
			redirect forum_threads_path
		else
			@user = ForumUser.new
			erb :'forum_users/login.html'
		end
	end

	post login_path do
		begin
			@user = ForumUser.find_by(trim_whitespace({username: params[:forum_user][:username]}, [:username]))
		rescue ActiveRecord::RecordNotFound 
			@user = nil
		end
		if @user && !@user.banned && @user.authenticate(params[:forum_user][:password])
			session[:forum_user_id] = @user.id
			@user.update(last_active: Time.now)
			redirect forum_threads_path
		else
			if @user.nil?
				@user = ForumUser.new
				@user.errors.add(:base, "Your credentials are invalid.")
			elsif !@user.authenticate(params[:forum_user][:password])
				@user.errors.add(:base, "Your credentials are invalid.")
			end
			@user.errors.add(:base, "User is banned.") if @user.banned
			erb :'forum_users/login.html'
			# redirect '/login'
		end
	end

	delete sessions_path do
		if logged_in?
			session.clear
			redirect root_path
		else
			redirect root_path
		end
	end

end