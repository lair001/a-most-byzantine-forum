require 'spec_helper'

class Request

	attr_accessor :path_info

end

class Helper

	include Helpable

	ATTR_ARRAY = [ 
		:session,  
		:user_posts,   
		:threads,
		:users,
		:thread_posts,
		:slug,
		:params,
		:request 
	]

	ATTR_ARRAY.each { |attr| attr_accessor attr }

	def initialize
		self.request = Request.new
		self.params = {}
	end

	def redirect(string)
		string
	end

	def view_current_user
		@current_user.dup.freeze
	end

end

describe 'Helpable' do 

	before do
	  	@helper1 = Helper.new

	  	@user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
	  	@user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
	  	@user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
	end

	describe '#logged in' do 

	  	it 'returns true if session[:forum_user_id] is set' do 
	  		@helper1.session = { forum_user_id: 1 }
	  		expect(@helper1.logged_in?).to eq(true)
	  	end

	  	it 'returns false if session[:forum_user_id] is not set' do 
	  		@helper1.session = {}
	  		expect(@helper1.logged_in?).to eq(false)
	  	end

	end

	describe '#current_user' do 

	  	it 'returns the current user' do 
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.view_current_user.username).to eq("hal")
	  	end

	end

	describe '#moderator' do 

	  	it 'returns true if the current user is a moderator' do
	  		@helper1.session = { forum_user_id: 3 }
	  		@helper1.current_user
	  		expect(@helper1.moderator?).to eq(true)
	  	end

	  	it 'returns false if the current user is not a moderator' do
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.moderator?).to eq(false)
	  	end

	end

	describe '#administrator' do 

  		it 'returns true if the current user is a administrator' do
	  		@helper1.session = { forum_user_id: 4 }
	  		@helper1.current_user
	  		expect(@helper1.administrator?).to eq(true)
  		end

  		it 'returns false if the current user is not administratator' do
	  		@helper1.session = { forum_user_id: 2 }
	  		@helper1.current_user
	  		expect(@helper1.administrator?).to eq(false)
	  	end

  	end

  	describe '#current_route' do 

  		it 'returns the current route' do 
  			@helper1.request.path_info = '/'
  			expect(@helper1.current_route).to eq('/')
  		end

  	end

  	describe '#format_time' do 

  		it 'formats Time objects' do 
  			@time1 = Time.new(2011, 11, 11, 11, 11, 11, "+00:00")
  			expect(@helper1.format_time(@time1)).to eq("2011/11/11 11:11:11")
  		end

  	end

	describe '#to_slug' do 

  		it 'slugifies strings and sets the result to @slug if @slug is not already set' do 
  			expect(@helper1.to_slug("The Great")).to eq("the-great")
  			expect(@helper1.to_slug("The-worst First")).to eq("the-great")
  			@helper1.slug = nil
  			expect(@helper1.to_slug("The-worst First")).to eq("the-worst-first")
  		end

  	end

  	describe '#cached_route_or_home' do 

  		it 'redirects to a cached path if set or home if there is no cached path' do 
  			expect(@helper1.cached_route_or_home).to eq('/')
  			@helper1.params[:cached_route] = '/threads'
  			expect(@helper1.cached_route_or_home).to eq('/threads')
  		end

  	end

  	describe '#set_attributes' do 

  		it 'it sets attributes of an object that are permitted to be set using values in a hash' do 
  			@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
  			attr_hash = { username: "bill", email: "bill@bill.com", password: "bill", banned: true }
  			settable_attr_array = ["username", "email", "password"]
  			@helper1.set_attributes(@user1, attr_hash, settable_attr_array)
  			expect(@user1.username).to eq("bill")
  			expect(@user1.email).to eq("bill@bill.com")
  			expect(@user1.password).to eq("bill")
  			expect(@user1.banned).to eq(false)
  			attr_hash = { username: "will", email: "will@will.com", password: "will", banned: true }
  			settable_attr_array = [:email, :password, :banned]
  			@helper1.set_attributes(@user1, attr_hash, settable_attr_array)
  			expect(@user1.username).to eq("bill")
  			expect(@user1.email).to eq("will@will.com")
  			expect(@user1.password).to eq("will")
  			expect(@user1.banned).to eq(true)
  		end

  	end

end