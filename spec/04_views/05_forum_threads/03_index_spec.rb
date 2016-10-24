require 'sinatra_helper'
require 'views_spec_helper'
require 'helpers_spec_helper'

describe 'forum_threads/index' do

  before do
  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)

    @thread1 = ForumThread.create(title: "the worst first", id: 1)
    @thread2 = ForumThread.create(title: "Michael Jackson is a very bad boy", id: 2)
    @thread3 = ForumThread.create(title: "The Lion, the Witch, and Madeline Albright", id: 3)
    @thread4 = ForumThread.create(title: "Hello and Goodbye, Phil")

    @post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
    @post8 = ForumPost.create(content: "I like the lion.", forum_user_id: 1, forum_thread_id: 3)

    @thread_array = ForumThread.all.sort { |a, b| b.updated_at <=> a.updated_at }

    @helper1 = Helper.new
  end

  it 'renders a listing of all threads (threads updated recently come first)' do 
  	use_view_to_login_as(@user2)
    visit '/forum_threads'

    #testing for order of threads using css selectors
    thread_selector = 'div.forum-divider-top div.row a'
    @thread_array.each do |thread|
    	expect(page.body).to include(@helper1.format_time(thread.updated_at))
    	expect(page.body).to include(@helper1.format_time(thread.created_at))
    	expect(page.first(thread_selector + "[href='/forum_threads/#{thread.slug}']").text).to include(thread.title)
    	thread_selector = 'div.forum-divider-top+' + thread_selector
    end
    page.assert_selector('div.row a', count: ForumThread.all.count)
  end

  it 'has a form to find a user by username' do 
  	use_view_to_login_as(@user2)
    visit '/forum_threads'
    expect(page).to have_css('form[method="post"][action="/forum_threads/search"]')
    expect(page).to have_no_field("_method")
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_css('input[name="forum_thread[title]"][placeholder="Title Search"]')
    visit '/forum_threads?message=Title+not+found.'
    expect(page).to have_css('input[name="forum_thread[title]"][placeholder="Title not found."]')
  end

  it 'renders buttons to edit and delete threads if logged in as a moderator' do 
    use_view_to_login_as(@user3)
    visit '/forum_threads'
    expect(page).to have_css('form[method="post"][action="/forum_threads"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="delete"]')
    @thread_array.each do |thread|
      expect(page).to have_link('Edit', href: "/forum_threads/#{thread.slug}/edit")
      expect(page).to have_css("input[type='hidden'][name='forum_thread[id]'][value='#{thread.id}']")
    end
  end

  it 'does not render buttons to edit and delete threads if not logged in as a moderator' do
    use_view_to_login_as(@user2)
    visit '/forum_threads'
    expect(page).to have_no_css('form[method="post"][action="/forum_threads"]')
    expect(page).to have_no_css('input[type="hidden"][name="_method"][value="delete"]')
    @thread_array.each do |thread|
      expect(page).to have_no_link('Edit', href: "/forum_threads/#{thread.slug}/edit")
      expect(page).to have_no_css("input[type='hidden'][name='forum_thread[id]'][value='#{thread.id}']")
    end
  end

end