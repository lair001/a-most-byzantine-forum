require 'spec_helper'

class Errors

	attr_accessor :all

	def initialize
		self.all = []
	end

	def add(symbol, string)
		all << [symbol, string]
	end

end

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

	def self.attribute_method?(symbol)
		symbol == :username ? true : false
	end

end

class SlugTitle

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	attr_accessor :title

	def self.attribute_method?(symbol)
		symbol == :title ? true : false
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

		describe '#slug' do 

			it "slugifies an instance's username if it has a username" do 
				expect(@slug4.slug).to eq("the-great-some1")
			end

			it "slugifies an instance's title if it has a username" do 
				@slug_title = SlugTitle.new
				@slug_title.title = "catcher In-sOme Hay"
				expect(@slug_title.slug).to eq("catcher-in-some-hay")
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