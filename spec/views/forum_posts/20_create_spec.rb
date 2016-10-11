require 'spec_helper'

describe 'forum_posts/create' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @thread1 = ForumThread.create(title: "The Bad", id: 1)
  end

  it 'renders a create post form with a field for thread title' do
    visit '/login'
    fill_in("username", with: "val")
    fill_in("password", with: "val")
    click_button 'login'
  	visit "/forum_posts/new/#{@thread1.slug}?cached_post=My+bad,+dude."
    expect(page.body).to include("#{@thread1.title}")
  	expect(page).to have_css('form[method="post"][action="/forum_posts"]')
    expect(page).to have_no_field("_method")
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_post[content]')
    expect(page.first('textarea#content').text).to include("My bad, dude.")
    expect(page).to have_css("input[type='hidden'][name='forum_post[forum_user_id]'][value='#{@user1.id}']")
    expect(page).to have_css("input[type='hidden'][name='forum_post[forum_thread_id]'][value='#{@thread1.id}']")
    expect(page).to have_css("input[type='hidden'][name='cached_route'][value='/forum_posts/new/#{@thread1.slug}']")
  end

end