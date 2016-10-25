require 'sinatra_helper'
# require 'views_spec_helper'
# require 'helpers_spec_helper'

describe 'forum_users/index' do

  before do
  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
    @user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)

    @user_array = ForumUser.all.sort { |a, b| a.username <=> b.username }

    @helper1 = Helper.new
  end

  it 'renders an alphabetical listing of all users' do 
  	use_view_to_login_as(@user1)
    visit '/forum_users'

    #testing for order of users using css selectors
    user_selector = 'div.forum-divider-top div.row a'
    @user_array.each do |user|
    	expect(page.body).to include(@helper1.format_time(user.updated_at))
    	expect(page.body).to include(@helper1.format_time(user.created_at))
    	expect(page.body).to include(user.email)
    	expect(page.first(user_selector + "[href='/forum_users/#{user.slug}']").text).to include(user.username)
    	user_selector = 'div.forum-divider-top+' + user_selector
    end
    page.assert_selector('div.row a', count: ForumUser.all.count)
  end

  it 'has a form to find a user by username' do 
  	use_view_to_login_as(@user1)
    visit '/forum_users'
    expect(page).to have_css('form[method="post"][action="/forum_users/search"]')
    expect(page).to have_no_field("_method")
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_css('input[name="forum_user[username]"][placeholder="Username Search"]')
    visit '/forum_users?message=Username+not+found.'
    expect(page).to have_css('input[name="forum_user[username]"][placeholder="Username not found."]')
  end

end