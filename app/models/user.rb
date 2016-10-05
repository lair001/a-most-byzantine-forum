module Byzantine
	class User < ActiveRecord::Base

		include Byzantine::Slugifiable::InstanceMethods
		extend Byzantine::Slugifiable::ClassMethods

		has_many :posts
		has_many :threads, through: :posts
		has_secure_password

	end
end