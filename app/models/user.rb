class User < Sinatra::Base

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :posts
	has_many :threads, through: :posts
	has_secure_password

end