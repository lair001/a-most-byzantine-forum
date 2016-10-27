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
	helpers PagesHelper::Titles
	helpers PagesHelper::Taglines
	helpers HtmlTagHelper

	helpers PathsHelper::Application
	helpers PathsHelper::ForumUsers
	helpers PathsHelper::ForumThreads
	helpers PathsHelper::ForumPosts
	helpers PathsHelper::Sessions

	register PathsHelper::Application
	register PathsHelper::ForumUsers
	register PathsHelper::ForumThreads
	register PathsHelper::ForumPosts
	register PathsHelper::Sessions

end