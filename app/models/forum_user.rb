class ForumUser < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Slugifiable::InstanceMethods
	include Currentable::InstanceMethods

	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_threads, through: :forum_posts

	has_secure_password
	validates :username, length: { in: 2..20 }
	validates :email, format: { with: /\A[^.]+@(.)+\.[^.\d]+\z/, message: "must have proper format." }

	validate do
		presence_of_unique_slug
		absence_of_forbidden_characters_in :username
		absence_of_forbidden_characters_in :password
		only_spaces_as_whitespace_in :username
		absence_of_whitespace_in :email
		absence_of_whitespace_in :password
	end

	before_create :set_initial_activity

	after_update :update_current_user_activity

	def slug
		@slug ||= self.slugify(:username)
	end

	def title
		@title ||= self.grant_title
	end

	def grant_title
		if self.banned
			"Banned"
		elsif self.administrator && self.moderator
			"Superuser"
		elsif self.administrator
			"Administrator"
		elsif self.moderator
			"Moderator"
		else
			"Courtier"
		end
	end

private

	def set_initial_activity
		self.last_active = Time.now
	end

end
