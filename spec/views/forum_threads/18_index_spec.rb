require 'spec_helper'

describe 'forum_threads/index' do

  before do
  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)

    @thread1 = ForumThread.create(title: "the worst first", id: 1)
    @thread2 = ForumThread.create(title: "Michael Jackson is a very bad boy", id: 2)
    @thread3 = ForumThread.create(title: "The Lion, the Witch, and Madeline Albright", id: 3)
    @thread4 = ForumThread.create(title: "Hello and Goodbye, Phil")

    @post2 = ForumPost.create(content: "Hal, do you want to be the first to be banned?", forum_user_id: 1, forum_thread_id: 1)

    @thread_array = ForumThread.all.sort { |a, b| b.updated_at <=> a.updated_at }

    @helper1 = Helper.new
  end

  it 'renders a listing of all threads (threads updated recently come first)' do 
  	visit '/login'
    fill_in("username", with: "val")
    fill_in("password", with: "val")
    click_button 'login'
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
  	visit '/login'
    fill_in("username", with: "val")
    fill_in("password", with: "val")
    click_button 'login'
    visit '/forum_threads'
    expect(page).to have_css('form[method="post"][action="/forum_threads/search"]')
    expect(page).to have_no_field("_method")
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_css('input[name="forum_thread[title]"][placeholder="Title Search"]')
    visit '/forum_threads?message=Title+not+found.'
    expect(page).to have_css('input[name="forum_thread[title]"][placeholder="Title not found."]')
  end

end