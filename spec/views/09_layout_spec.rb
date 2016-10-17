require 'spec_helper'

describe 'layout' do

	before do
	  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true)
	  	@thread1 = ForumThread.create(title: "the worst first", id: 1)
	  	@thread2 = ForumThread.create(title: "Michael Jackson is a very bad boy", id: 2)
	end

	it 'has a title: A Most Byzantine Forum' do 
		visit '/'
		expect(page.first('title').text).to eq('A Most Byzantine Forum')
	end

	it 'links to forum.css if the current route is not / or /C11P' do 
	  	use_view_to_login_as(@user1)
	  	expect(page.body).to include('<link rel="stylesheet" href="/stylesheets/forum.css">')
	  	visit '/'
	  	expect(page.body).not_to include('<link rel="stylesheet" href="/stylesheets/forum.css">')
	  	visit '/C11P'
	  	expect(page.body).not_to include('<link rel="stylesheet" href="/stylesheets/forum.css">')
	end

	it 'links to C11P.css if the current route is /C11P' do 
	  	visit '/C11P'
	  	expect(page.body).to include('<link rel="stylesheet" href="/stylesheets/C11P.css">')
	  	visit '/'
	  	expect(page.body).not_to include('<link rel="stylesheet" href="/stylesheets/C11P.css">')
	end

	it 'renders a navbar brand with a link to / if the current route is /C11P and to /C11P otherwise' do 
		visit '/C11P'
		expect(page).to have_link('', href: '/')
		expect(page).to have_no_link('', href: '/C11P')
		visit '/'
		expect(page).to have_no_link('', href: '/')
		expect(page).to have_link('', href: '/C11P')
	end

	it 'renders a navbar link to logout if logged in and current route is not /C11P' do 
		visit '/'
		expect(page).to have_no_link('Logout', href: '/logout')
		visit '/C11P'
		expect(page).to have_no_link('Logout', href: '/logout')
		use_view_to_login_as(@user1)
		expect(page).to have_link('Logout', href: '/logout')
		visit '/'
		expect(page).to have_link('Logout', href: '/logout')
		visit '/C11P'
		expect(page).to have_no_link('Logout', href: '/logout')
	end

	it "renders a navbar link to the current user's profile if logged in and the current route is neither /C11P or the current user's profile page" do 
		use_view_to_login_as(@user1)
		visit '/C11P'
		expect(page).to have_no_link('Profile', href: "/forum_users/#{@user1.slug}")
		visit "/forum_users/#{@user1.slug}"
		expect(page).to have_no_link('Profile', href: "/forum_users/#{@user1.slug}")
		visit '/forum_threads'
		expect(page).to have_link('Profile', href: "/forum_users/#{@user1.slug}")
	end

	it "renders a navbar link to /forum_users if logged in and the current route is neither /C11P or /forum_users" do 
		use_view_to_login_as(@user1)
		visit '/C11P'
		expect(page).to have_no_link('Users', href: "/forum_users")
		visit "/forum_users"
		expect(page).to have_no_link('Users', href: "/forum_users")
		visit '/forum_threads'
		expect(page).to have_link('Users', href: "/forum_users")
	end

	it "renders a navbar link to /forum_threads if logged in and the current route is neither /C11P or /forum_threads" do 
		use_view_to_login_as(@user1)
		visit '/C11P'
		expect(page).to have_no_link('Threads', href: "/forum_threads")
		visit "/forum_users"
		expect(page).to have_link('Threads', href: "/forum_threads")
		visit '/forum_threads'
		expect(page).to have_no_link('Threads', href: "/forum_threads")
	end

	it 'has extra navigation links if the path is /C11P' do 
	  	visit '/C11P'
	  	expect(page).to have_link('Statue', href: '#Statue')
	  	expect(page).to have_link('Timeline', href: '#Timeline')
	  	expect(page).to have_link('Painting', href: '#Painting')

	  	visit '/'
	  	expect(page).to have_no_link('Statue', href: '#Statue')
	  	expect(page).to have_no_link('Timeline', href: '#Timeline')
	  	expect(page).to have_no_link('Painting', href: '#Painting')
	end

	it 'has dropdown menus for Places and People if the path is /C11P' do
	  	visit '/C11P'
	  	expect(page.first('li.dropdown+li.dropdown').text).to include('Places')
	  	expect(page.first('li.dropdown+li.dropdown+li.dropdown').text).to include('People')
	  	visit '/'
	  	expect(page.first('li.dropdown+li.dropdown')).to eq(nil)
	  	expect(page.first('li.dropdown+li.dropdown+li.dropdown')).to eq(nil)
	end

	it 'renders a navbar link to /forum_threads/new if the current route is /forum_threads' do 
	  	use_view_to_login_as(@user1)
	  	visit '/forum_threads'
	  	expect(page).to have_link('Create', href: '/forum_threads/new')
	  	visit "/forum_threads/#{@thread1.slug}"
	  	expect(page).to have_no_link('Create', href: '/forum_threads/new')
	  	visit "/forum_threads/#{@thread2.slug}"
	  	expect(page).to have_no_link('Create', href: '/forum_threads/new')
	  	visit "/"
	  	expect(page).to have_no_link('Create', href: '/forum_threads/new')
	end

	it 'renders to navbar link to /forum_posts/new/:slug if the current route is /forum_threads/:slug' do 
	  	use_view_to_login_as(@user1)
	  	visit "/forum_threads"
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread1.slug}")
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread2.slug}")
	  	visit "/forum_threads/#{@thread1.slug}"
	  	expect(page).to have_link('Create', href: "/forum_posts/new/#{@thread1.slug}")
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread2.slug}")
	  	visit "/forum_threads/#{@thread2.slug}"
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread1.slug}")
	  	expect(page).to have_link('Create', href: "/forum_posts/new/#{@thread2.slug}")
	  	visit "/"
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread1.slug}")
	  	expect(page).to have_no_link('Create', href: "/forum_posts/new/#{@thread2.slug}")
	end

	it 'it renders Facebook and tumblr. links if current route is /C11P' do 
		visit '/C11P'
	  	expect(page).to have_link('Facebook', href: 'https://www.facebook.com/pages/Constantine-XI-Palaiologos/103225189731462?fref=ts')
	  	expect(page).to have_link('tumblr.', href: 'https://www.tumblr.com/search/constantine-xi-palaiologos')

	  	visit '/'
	  	expect(page).to have_no_link('Facebook', href: 'https://www.facebook.com/pages/Constantine-XI-Palaiologos/103225189731462?fref=ts')
	  	expect(page).to have_no_link('tumblr.', href: 'https://www.tumblr.com/search/constantine-xi-palaiologos')
	end

	it "renders a link to the author's homepage" do 
		use_view_to_login_as(@user1)
		visit '/'
		expect(page).to have_link('Samuel Lair', href: 'http://samlair.com')
		visit '/C11P'
		expect(page).to have_link('Samuel Lair', href: 'http://samlair.com')
		visit '/forum_threads'
		expect(page).to have_link('Samuel Lair', href: 'http://samlair.com')
	end

end