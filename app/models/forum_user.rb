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
		absence_of_whitespace_in :email
		absence_of_whitespace_in :password
	end

	# def absence_of_whitespace_in_password  
	# 	if self.password && self.password.match(/\s/)
	# 		errors.add(:base, 'password cannot contain whitespace.')
	# 	end
	# end

	def slug
		self.slugify(:username)
	end

end
