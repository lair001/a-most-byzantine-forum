class Controller < Sinatra::Base

	configure do
		set :public_folder, 'app/assets'
		set :views, 'app/views'
		set :erb, layout: :'layouts/application.html'
		enable :sessions
		set :session_secret, "manzikert"
	end

	helpers ForumUsersHelper
	helpers ForumThreadsHelper
	helpers ForumPostsHelper
	helpers ApplicationHelper
	helpers RoutesHelper
	helpers TitlesHelper
	helpers TaglinesHelper

	helpers PathsHelper
	register PathsHelper

end