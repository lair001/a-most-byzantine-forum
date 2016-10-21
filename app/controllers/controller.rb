class Controller < Sinatra::Base

	configure do
		set :public_folder, 'app/assets'
		set :views, 'app/views'
		enable :sessions
		set :session_secret, "manzikert"
	end

	helpers Helpable

end