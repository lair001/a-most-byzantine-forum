require 'spec_helper'

describe 'forum_threads/new' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
  end

  it 'renders a create thread form with fields for thread title and content for the first post' do
    use_view_to_login_as(@user1)
  	visit '/forum_threads/new'
  	expect(page).to have_css('form[method="post"][action="/forum_threads"]')
    expect(page).to have_no_field("_method")
    expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_thread[title]')
  	expect(page).to have_field('forum_post[content]')
  end

  it 'shows errors if thread creation is unsuccessful' do
    use_view_to_login_as(@user1)
    visit '/forum_threads/new'
    click_button 'create_thread'
    expect(page.first("blockquote footer").text).to eq("The Basileus")
  end

end