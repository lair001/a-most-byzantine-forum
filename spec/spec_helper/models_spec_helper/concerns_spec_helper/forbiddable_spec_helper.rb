require 'errors_spec_helper'

class Forbidder

	include Forbiddable::InstanceMethods

	attr_accessor :errors, :username, :title, :attribute

	def initialize
		self.errors = Errors.new
	end

end