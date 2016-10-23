class Controller < Sinatra::Base

	configure do
		set :public_folder, 'app/assets'
		set :views, 'app/views'
		set :erb, layout: :'layout.html'
		enable :sessions
		set :session_secret, "manzikert"
	end

	helpers ApplicationHelper

end