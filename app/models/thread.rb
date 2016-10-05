module Byzantine
	class Thread < ActiveRecord::Base

		include Slugifiable::InstanceMethods
		extend Slugifiable::ClassMethods

		has_many :posts
		has_many :users, through: :posts

	end
end