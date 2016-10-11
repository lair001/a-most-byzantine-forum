require 'spec_helper'

describe 'forum_users/edit' do

  before do
    @user2 = ForumUser.create(username: "hal", email: "hal@hal.com", password: "hal", id: 2)
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true, id: 3)
    @user4 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true, id: 4)
  end

  it 'renders a edit user form with fields for username, email, and password if logged in as an administrator' do
    visit '/login'
    fill_in("username", with: "wal")
    fill_in("password", with: "wal")
    click_button 'login'
  	visit '/forum_users/wal/edit'
  	expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_user[username]')
  	expect(page).to have_field('forum_user[email]')
  	expect(page).to have_field('forum_user[password]')
  end

  it 'renders a edit user form with fields for username, email, and password but not username if logged in as a moderator' do
    visit '/login'
    fill_in("username", with: "sal")
    fill_in("password", with: "sal")
    click_button 'login'
    visit '/forum_users/sal/edit'
    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_no_field('forum_user[username]')
    expect(page).to have_field('forum_user[email]')
    expect(page).to have_field('forum_user[password]')
  end

  it 'renders a edit user form with fields for username, email, and password but not username if logged in as an ordinary user' do
    visit '/login'
    fill_in("username", with: "hal")
    fill_in("password", with: "hal")
    click_button 'login'
    visit '/forum_users/hal/edit'
    expect(page).to have_css('form[method="post"][action="/forum_users"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
    expect(page).to have_css('button[type="submit"]')
    expect(page).to have_no_field('forum_user[username]')
    expect(page).to have_field('forum_user[email]')
    expect(page).to have_field('forum_user[password]')
  end

end