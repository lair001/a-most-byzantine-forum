# require 'errors_spec_helper'

class SlugUsername

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	attr_accessor :username, :errors

	cattr_accessor :all

	self.all = []

	def initialize(username = nil)
		self.username = username
		self.errors = Errors.new
		self.class.all << self
	end

	def slug
		self.slugify(:username)
	end

end

class SlugTitle

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	attr_accessor :title

	def slug
		self.slugify(:title)
	end

end