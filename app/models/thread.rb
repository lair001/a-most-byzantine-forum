class Thread < Sinatra::Base

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :posts
	has_many :users, through: :posts

end