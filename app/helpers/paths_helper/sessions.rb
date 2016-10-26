module PathsHelper

	module Sessions

		def login_path
			"/login"
		end

		def logout_path
			"/logout"
		end

		def sessions_path
			"/sessions"
		end

		def new_session_path
			login_path
		end

	end

end