class ForumUser < ActiveRecord::Base

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_threads, through: :forum_posts
	has_secure_password

end
