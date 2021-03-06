class ForumThread < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Slugifiable::InstanceMethods
	include Currentable::InstanceMethods

	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_users, through: :forum_posts

	validates :title, length: { in: 2..100 }

	validate do 
		presence_of_unique_slug
		absence_of_forbidden_characters_in :title
		only_spaces_as_whitespace_in :title
	end

	after_destroy :update_current_user_activity

	after_update :update_current_user_activity

	def slug
		@slug ||= self.slugify(:title)
	end

	def forum_post_attributes=(attributes_hash)
		self.forum_posts.build(attributes_hash)
	end

end
