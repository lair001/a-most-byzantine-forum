require 'spec_helper'
require 'errors_helper'

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

describe 'Slugifiable' do 

	before do 
		SlugUsername.all.clear
		@slug1 = SlugUsername.new('the great')
		@slug2 = SlugUsername.new('The-Great')
		@slug3 = SlugUsername.new('tiMmy jOnes')
		@slug4 = SlugUsername.new("tHe-gReat SoMe1")
	end

	describe 'InstanceMethods' do 

		describe '#slugify' do 

			it "slugifies an instance's attribute" do 
				expect(@slug4.slugify(:username)).to eq("great-some1")

				@slug_title = SlugTitle.new
				@slug_title.title = "a;catcher In-sOme Hay:zero"
				expect(@slug_title.slugify(:title)).to eq("catcher-some-hay")
			end

		end

		describe '#presence_of_unique_slug' do 

			it 'adds an error if a slug is not present' do
				@slug5 = SlugUsername.new
				@slug5.presence_of_unique_slug
				expect(@slug5.errors.all).to include([:base, 'Must have a slug.'])

			end

			it 'adds an error if the slug is not unique' do
				@slug1.presence_of_unique_slug
				@slug2.presence_of_unique_slug
				expect(@slug1.errors.all).to include([:base, 'Must have a unique slug.'])
				expect(@slug2.errors.all).to include([:base, 'Must have a unique slug.'])
			end

		end

	end

	describe 'ClassMethods' do 

		describe '#find_by_slug' do 

			it "returns an instance whose slug matches the argument" do 
				expect(SlugUsername.find_by_slug('timmy-jones')).to eq(@slug3)
			end

			it "returns nil if no instance has a slug that matches the argument" do 
				expect(SlugUsername.find_by_slug('igor-vladimir')).to eq(nil)
			end

		end

		describe '#validate_by_slug' do 

			it "returns true if an instance's slug is unique" do 
				expect(SlugUsername.validate_by_slug(@slug3)).to eq(true)
			end

			it "returns false if an instance's slug is shared by another instance" do 
				expect(SlugUsername.validate_by_slug(@slug1)).to eq(false)
				expect(SlugUsername.validate_by_slug(@slug2)).to eq(false)
			end

		end

	end

end