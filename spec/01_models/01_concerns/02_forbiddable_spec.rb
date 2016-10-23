require 'spec_helper'
require 'forbiddable_helper'

describe 'Forbiddable' do

	before do
		@forbidder1 = Forbidder.new
	end

	describe 'InstanceMethods' do

		describe 'absence_of_whitespace_in' do

			it 'forbids the presence of whitespace in an attribute' do
				@forbidder1.username = "peter\nwebs"
				@forbidder1.absence_of_whitespace_in(:username)
				expect(@forbidder1.errors.all).to include([:base, "username cannot contain whitespace."])

				@forbidder1.title = "The\fGreat"
				@forbidder1.absence_of_whitespace_in(:title)
				expect(@forbidder1.errors.all).to include([:base, "title cannot contain whitespace."])

				@forbidder1.attribute = "Blue…99"
				@forbidder1.absence_of_whitespace_in(:attribute)
				expect(@forbidder1.errors.all).to include([:base, "attribute cannot contain whitespace."])

				@forbidder1.errors.clear

				@forbidder1.username = "peter webs"
				@forbidder1.absence_of_whitespace_in(:username)
				expect(@forbidder1.errors.all).to include([:base, "username cannot contain whitespace."])

				@forbidder1.title = "TheGreat"
				@forbidder1.absence_of_whitespace_in(:title)
				expect(@forbidder1.errors.all).not_to include([:base, "title cannot contain whitespace."])
			end

		end

		describe '#absence_of_forbidden_characters_in' do

			it 'forbids the presence of forbidden characters in an attribute' do 
				@forbidder1.title = "The⚑Great"
				@forbidder1.absence_of_forbidden_characters_in :title
				expect(@forbidder1.errors.all).to include([:base, "title cannot have forbidden characters."])

				@forbidder1.username = "The⚐Great"
				@forbidder1.absence_of_forbidden_characters_in "username"
				expect(@forbidder1.errors.all).to include([:base, "username cannot have forbidden characters."])

				@forbidder1.attribute = "The⚉Great"
				@forbidder1.absence_of_forbidden_characters_in :attribute
				expect(@forbidder1.errors.all).to include([:base, "attribute cannot have forbidden characters."])
				@forbidder1.errors.clear

				@forbidder1.title = "The⚈Great"
				@forbidder1.absence_of_forbidden_characters_in "title"
				expect(@forbidder1.errors.all).to include([:base, "title cannot have forbidden characters."])

				@forbidder1.username = "The⚇Great"
				@forbidder1.absence_of_forbidden_characters_in :username
				expect(@forbidder1.errors.all).to include([:base, "username cannot have forbidden characters."])

				@forbidder1.attribute = "The⚆Great"
				@forbidder1.absence_of_forbidden_characters_in "attribute"
				expect(@forbidder1.errors.all).to include([:base, "attribute cannot have forbidden characters."])

				@forbidder1.errors.clear

				@forbidder1.title = "The-Biggest-Nobody"
				@forbidder1.absence_of_forbidden_characters_in "title"
				expect(@forbidder1.errors.all).not_to include([:base, "title cannot have forbidden characters."])

				@forbidder1.username = "peter_webs"
				@forbidder1.absence_of_forbidden_characters_in :username
				expect(@forbidder1.errors.all).not_to include([:base, "username cannot have forbidden characters."])

				@forbidder1.attribute = "blue99"
				@forbidder1.absence_of_forbidden_characters_in "attribute"
				expect(@forbidder1.errors.all).not_to include([:base, "attribute cannot have forbidden characters."])
			end

		end

		describe 'only_spaces_as_whitespace_in' do

			it 'validates that the only whitespace in an attribute is space' do 
				@forbidder1.username = "peter\nwebs"
				@forbidder1.only_spaces_as_whitespace_in(:username)
				expect(@forbidder1.errors.all).to include([:base, "username can only contain spaces as whitespace."])

				@forbidder1.title = "The\fGreat"
				@forbidder1.only_spaces_as_whitespace_in(:title)
				expect(@forbidder1.errors.all).to include([:base, "title can only contain spaces as whitespace."])

				@forbidder1.attribute = "Blue…99"
				@forbidder1.only_spaces_as_whitespace_in(:attribute)
				expect(@forbidder1.errors.all).to include([:base, "attribute can only contain spaces as whitespace."])

				@forbidder1.errors.clear

				@forbidder1.username = "peter webs"
				@forbidder1.only_spaces_as_whitespace_in(:username)
				expect(@forbidder1.errors.all).not_to include([:base, "username can only contain spaces as whitespace."])

				@forbidder1.title = "The Great"
				@forbidder1.only_spaces_as_whitespace_in(:title)
				expect(@forbidder1.errors.all).not_to include([:base, "title can only contain spaces as whitespace."])

				@forbidder1.attribute = "Blue 99"
				@forbidder1.only_spaces_as_whitespace_in(:attribute)
				expect(@forbidder1.errors.all).not_to include([:base, "attribute can only contain spaces as whitespace."])
			end

		end

	end

end