require 'spec_helper'

class Errors

	attr_accessor :all

	def initialize
		self.all = []
	end

	def add(symbol, string)
		all << [symbol, string]
	end

	def clear 
		all.clear
	end

end

class Forbidder

	include Forbiddable::InstanceMethods

	attr_accessor :errors, :username, :title, :attribute

	def initialize
		self.errors = Errors.new
	end

end

describe 'Forbiddable' do 

	before do 
		@forbidder1 = Forbidder.new
	end

	describe 'InstanceMethods' do 

		describe '#absence_of_forbidden_characters' do 
			it 'forbids the presence of forbidden characters in an attribute' do 
				@forbidder1.title = "The+Great"
				@forbidder1.absence_of_forbidden_characters :title
				expect(@forbidder1.errors.all).to include([:base, "title cannot have forbidden characters."])
				@forbidder1.username = "The&Great"
				@forbidder1.absence_of_forbidden_characters "username"
				expect(@forbidder1.errors.all).to include([:base, "username cannot have forbidden characters."])
				@forbidder1.attribute = "The#Great"
				@forbidder1.absence_of_forbidden_characters :attribute
				expect(@forbidder1.errors.all).to include([:base, "attribute cannot have forbidden characters."])
				@forbidder1.errors.clear

				@forbidder1.title = "The@Great"
				@forbidder1.absence_of_forbidden_characters "title"
				expect(@forbidder1.errors.all).to include([:base, "title cannot have forbidden characters."])
				@forbidder1.username = "The%Great"
				@forbidder1.absence_of_forbidden_characters :username
				expect(@forbidder1.errors.all).to include([:base, "username cannot have forbidden characters."])
				@forbidder1.attribute = "The$Great"
				@forbidder1.absence_of_forbidden_characters "attribute"
				expect(@forbidder1.errors.all).to include([:base, "attribute cannot have forbidden characters."])
				@forbidder1.errors.clear

				@forbidder1.title = "The-Biggest-Nobody"
				@forbidder1.absence_of_forbidden_characters "title"
				expect(@forbidder1.errors.all).not_to include([:base, "title cannot have forbidden characters."])
				@forbidder1.username = "peter_webs"
				@forbidder1.absence_of_forbidden_characters :username
				expect(@forbidder1.errors.all).not_to include([:base, "username cannot have forbidden characters."])
				@forbidder1.attribute = "blue99"
				@forbidder1.absence_of_forbidden_characters "attribute"
				expect(@forbidder1.errors.all).not_to include([:base, "attribute cannot have forbidden characters."])
			end
		end

	end

end