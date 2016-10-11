require 'spec_helper'

describe 'forum_threads/create' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
  end

  it 'renders a create thread form with fields for thread title and content for the first post' do
    visit '/login'
    fill_in("username", with: "val")
    fill_in("password", with: "val")
    click_button 'login'
  	visit '/forum_threads/new'
  	expect(page).to have_css('form[method="post"][action="/forum_threads"]')
    expect(page).to have_no_field("_method")
    expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_thread[title]')
  	expect(page).to have_field('forum_post[content]')
  end

end