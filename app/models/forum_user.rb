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

	validate :presence_of_unique_slug
	validate { absence_of_forbidden_characters :username }

end
