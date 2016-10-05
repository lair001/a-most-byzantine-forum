module Byzantine
	class Thread < ActiveRecord::Base

		include Byzantine::Slugifiable::InstanceMethods
		extend Byzantine::Slugifiable::ClassMethods

		has_many :posts
		has_many :users, through: :posts

	end
end