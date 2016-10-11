require 'spec_helper'

describe 'forum_posts/edit' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @thread1 = ForumThread.create(title: "The Bad", id: 1)
    @post1 = ForumPost.create(content: "Michael Jackson was bad, you know.", forum_user_id: 1, forum_thread_id: 1, id: 1)
  end

  it 'renders a create post form with a field for thread title' do
    visit '/login'
    fill_in("username", with: "val")
    fill_in("password", with: "val")
    click_button 'login'
  	visit "/forum_posts/#{@post1.id}/edit"
    expect(page.body).to include("Post ##{@post1.id}")
    expect(page.body).to include("#{@thread1.title}")
    expect(page.body).to include("#{@user1.username}")
  	expect(page).to have_css('form[method="post"][action="/forum_posts"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_post[content]')
    expect(page.first('textarea#content').text).to include("#{@post1.content}")
    expect(page).to have_css("input[type='hidden'][name='forum_post[id]'][value='#{@post1.id}']")
    expect(page).to have_css("input[type='hidden'][name='cached_route'][value='/forum_posts/#{@post1.id}/edit']")
  end

end