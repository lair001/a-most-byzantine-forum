require 'spec_helper'

class SlugUsername

	include Slugifiable::InstanceMethods
	extend Slugifiable::ClassMethods

	attr_accessor :username

	cattr_accessor :all

	self.all = []

	def self.attribute_method?(symbol)
		symbol == :username ? true : false
	end

	def initialize(username = nil)
		self.username = username
		self.class.all << self
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