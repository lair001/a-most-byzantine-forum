class ForumThread < ActiveRecord::Base

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_users, through: :forum_posts

	validates :title, presence: true

end
