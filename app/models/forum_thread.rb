class ForumThread < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_users, through: :forum_posts

	validates :title, presence: true

	validate :presence_of_unique_slug
	validate { absence_of_forbidden_characters :title }

end
