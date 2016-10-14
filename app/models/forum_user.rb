class ForumUser < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	has_many :forum_posts
	has_many :forum_threads, through: :forum_posts

	has_secure_password
	validates :username, presence: true
	validates :email, presence: true
	validates :password_digest, presence: true

	validate do
		presence_of_unique_slug
		absence_of_forbidden_characters_in :username
		absence_of_forbidden_characters_in :password
		only_spaces_as_whitespace_in :username
		absence_of_whitespace_in :email
		email_format
		absence_of_whitespace_in :password
	end

	def email_format
		errors.add(:base, "email must have proper format") if self.email.is_a?(String) && self.email.match(/^[^.]+@(.)+\.[^.\d]+$/).nil?
	end

	def slug
		self.slugify(:username)
	end

end
