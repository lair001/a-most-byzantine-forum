require 'spec_helper'

describe 'forum_threads/edit' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @thread1 = ForumThread.create(title: "The Bad", id: 1)
  end

  it 'renders a edit thread form with a field for thread title' do
    use_view_to_login_as(@user1)
  	visit "/forum_threads/#{@thread1.slug}/edit"
  	expect(page).to have_css('form[method="post"][action="/forum_threads"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_thread[title]')
  	expect(page).to have_no_field('forum_post[content]')
    expect(page).to have_css("input[type='hidden'][name='forum_thread[id]'][value='#{@thread1.id}']")
    expect(page).to have_css("input[type='hidden'][name='cached_route'][value='/forum_threads/#{@thread1.slug}/edit']")
  end

  it 'shows errors if thread editing is unsuccessful' do
    use_view_to_login_as(@user1)
    visit "/forum_threads/#{@thread1.slug}/edit"
    fill_in("title", with: "⥐")
    click_button 'edit_thread'
    expect(page.first("blockquote footer").text).to eq("The Basileus")
  end

end