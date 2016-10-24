require 'sinatra_helper'
require 'views_spec_helper'

describe 'forum_users/edit' do

  before do
    @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
    @user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
  end

  it 'renders a edit user form with fields for username, email, and password if logged in as an administrator' do
    use_view_to_login_as(@user4)
  	visit '/forum_users/wal/edit'
  	expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_user[username]')
  	expect(page).to have_field('forum_user[email]')
  	expect(page).to have_field('forum_user[password]')
  end

  it 'renders a edit user form with fields for username, email, and password but not username if logged in as a moderator' do
    use_view_to_login_as(@user3)
    visit '/forum_users/sal/edit'
    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_no_field('forum_user[username]')
    expect(page).to have_field('forum_user[email]')
    expect(page).to have_field('forum_user[password]')
  end

  it 'renders a edit user form with fields for username, email, and password but not username if logged in as an ordinary user' do
    use_view_to_login_as(@user2)
    visit '/forum_users/hal/edit'
    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_no_field('forum_user[username]')
    expect(page).to have_field('forum_user[email]')
    expect(page).to have_field('forum_user[password]')
  end

  it 'shows errors if user editing is unsuccessful' do
    use_view_to_login_as(@user4)
    visit "/forum_users/#{@user2.username}/edit"
    fill_in("username", with: "⥐")
    fill_in("password", with: "⥐")
    fill_in("password", with: "⥐")
    click_button 'edit_user'
    expect(page.first("blockquote footer").text).to eq("The Basileus")
  end

end