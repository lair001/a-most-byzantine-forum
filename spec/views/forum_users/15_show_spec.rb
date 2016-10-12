require 'spec_helper'

describe 'forum_users/show' do

  before do
    @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
    @user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
    @user6 = ForumUser.create(username: "zack", email: "zack@zack.com", password: "zack", id: 6)
    @user7 = ForumUser.create(username: "ed", email: "ed@ed.com", password: "ed", id: 7, banned: true)

    @thread1 = ForumThread.create(title: "the worst first", id: 1)

    @post1 = ForumPost.create(content: "asdf", forum_user_id: 2, forum_thread_id: 1)
    @post3 = ForumPost.create(content: "You insult my honor, my lady.", forum_user_id: 2, forum_thread_id: 1)
    @post5 = ForumPost.create(content: "Wait, my hand slipped. I swear!", forum_user_id: 2, forum_thread_id: 1)
    @post7 = ForumPost.create(content: "Fiddlesticks", forum_user_id: 2, forum_thread_id: 1)
    @post1.update(content: "I'm sorry, please don't ban me.", forum_user_id: 2, forum_thread_id: 1)
    @post3.update(content: "Maybe I was too confrontational.", forum_user_id: 2, forum_thread_id: 1)

    @user2_posts_array = @user2.forum_posts.sort { |a, b| b.updated_at <=> a.updated_at }

    @helper1 = Helper.new
  end

  it "renders a user profile with a listing of the user's posts (recently edited posts come first)" do
    view_login(@user6)
    visit "/forum_users/#{@user2.slug}"

    expect(page.body).to include(@user2.username)
    expect(page.body).to include(@user2.email)

    #testing for order of posts using css selectors
    post_selector = 'div.forum-divider-top div.row a'
    @user2_posts_array.each do |post|
    	expect(page.body).to include(@helper1.format_time(post.updated_at))
    	expect(page.body).to include(@helper1.format_time(post.created_at))
    	expect(page.body).to include(post.content)
    	expect(page.first(post_selector + "[href='/forum_threads/#{post.forum_thread.slug}##{post.id}']").text).to include(post.forum_thread.title)
    	post_selector = 'div.forum-divider-top+' + post_selector
    end
    page.assert_selector('div.row a', count: ForumPost.all.count)
  end

  it "renders a button to edit a user if logged in as an administrator" do
    view_login(@user4)
    visit "/forum_users/#{@user2.slug}"

    expect(page).to have_link('Edit', href: "/forum_users/#{@user2.slug}/edit")
    expect(page).to have_css('button[type="submit"]#edit')
  end

  it "renders a button to edit a user if logged as the user the page is for" do
    view_login(@user2)
    visit "/forum_users/#{@user2.slug}"

    expect(page).to have_link('Edit', href: "/forum_users/#{@user2.slug}/edit")
    expect(page).to have_css('button[type="submit"]#edit')
  end

  it "does not render a button to edit a user if logged as an ordinary user and visiting the show page of another user" do
    view_login(@user2)
    visit "/forum_users/#{@user6.slug}"

    expect(page).to have_no_link('Edit', href: "/forum_users/#{@user6.slug}/edit")
    expect(page).to have_no_css('button[type="submit"]#edit')
  end

  it "shows a button to ban the user if logged in as a moderator and visiting the show page of a user who is not banned" do
    view_login(@user3)
    visit "/forum_users/#{@user2.slug}"

    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('input[type="hidden"][name="forum_user[banned]"][value="1"]')
    expect(page).to have_css("input[type='hidden'][name='forum_user[id]'][value='#{@user2.id}']")
    expect(page).to have_css('button[type="submit"]#ban')
  end

  it "shows a button to unban the user if logged in as a moderator and visiting the show page of a user who is banned" do
    view_login(@user3)
    visit "/forum_users/#{@user7.slug}"

    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('input[type="hidden"][name="forum_user[banned]"][value="0"]')
    expect(page).to have_css("input[type='hidden'][name='forum_user[id]'][value='#{@user7.id}']")
    expect(page).to have_css('button[type="submit"]#unban')
  end

  it "does not show the ban and unban buttons if logged in as an ordinary user" do
    view_login(@user6)

    visit "/forum_users/#{@user2.slug}"
    expect(page).to have_no_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_no_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_no_css('input[type="hidden"][name="forum_user[banned]"][value="1"]')
    expect(page).to have_no_css("input[type='hidden'][name='forum_user[id]'][value='#{@user2.id}']")
    expect(page).to have_no_css('button[type="submit"]#ban')

    visit "/forum_users/#{@user7.slug}"
    expect(page).to have_no_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_no_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_no_css('input[type="hidden"][name="forum_user[banned]"][value="0"]')
    expect(page).to have_no_css("input[type='hidden'][name='forum_user[id]'][value='#{@user7.id}']")
    expect(page).to have_no_css('button[type="submit"]#unban')
  end

  it "does not show the ban and unban buttons if logged in as an administrator without moderator powers" do
    view_login(@user4)

    visit "/forum_users/#{@user2.slug}"
    expect(page).to have_no_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_no_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_no_css('input[type="hidden"][name="forum_user[banned]"][value="1"]')
    expect(page).to have_no_css("input[type='hidden'][name='forum_user[id]'][value='#{@user2.id}']")
    expect(page).to have_no_css('button[type="submit"]#ban')

    visit "/forum_users/#{@user7.slug}"
    expect(page).to have_no_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_no_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_no_css('input[type="hidden"][name="forum_user[banned]"][value="0"]')
    expect(page).to have_no_css("input[type='hidden'][name='forum_user[id]'][value='#{@user7.id}']")
    expect(page).to have_no_css('button[type="submit"]#unban')
  end


end