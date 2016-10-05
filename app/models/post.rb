class Post < Sinatra::Base

	belongs_to :user 
	belongs_to :thread

end