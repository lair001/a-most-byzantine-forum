class Controller < Sinatra::Base

	configure do
		set :public_folder, 'public'
		set :views, 'app/views'
		enable :sessions
		set :session_secret, "password_security"
	end

	helpers do
		def logged_in?
			!!session[:user_id]
		end

		def current_user
			@current_user ||= ForumUser.find(session[:user_id])
		end

		def moderator?
			@moderator ||= current_user.moderator
		end

		def administrator?
			@administrator ||= current_user.administrator
		end

		def current_route
			@current_route ||= request.path_info
		end

	end

end