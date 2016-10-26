require 'sinatra_helper'
# require 'views_spec_helper'

describe 'forum_posts/edit' do

  before do
    @user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true, id: 1)
    @thread1 = ForumThread.create(title: "The Bad", id: 1)
    @post1 = ForumPost.create(content: "Michael Jackson was bad, you know.", forum_user_id: 1, forum_thread_id: 1, id: 1)
  end

  it 'renders a create post form with a field for thread title' do
    use_view_to_login_as(@user1)
  	visit "#{helper.edit_forum_thread_forum_post_path(@thread1, @post1)}"
    expect(page.body).to include("Post ##{@post1.id}")
    expect(page.body).to include("#{@thread1.title}")
    expect(page.body).to include("#{@user1.username}")
  	expect(page).to have_css('form[method="post"][action="/forum_posts"]')
    expect(page).to have_css('input[type="hidden"][name="_method"][value="patch"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_post[content]')
    expect(page.first('textarea#content').text).to include("#{@post1.content}")
    expect(page).to have_css("input[type='hidden'][name='forum_post[id]'][value='#{@post1.id}']")
    expect(page).to have_css("input[type='hidden'][name='cached_route'][value='#{helper.edit_forum_thread_forum_post_path(@thread1, @post1)}']")
  end

  it 'shows errors if post editing is unsuccessful' do
    use_view_to_login_as(@user1)
    visit "#{helper.edit_forum_thread_forum_post_path(@thread1, @post1)}"
    fill_in("content", with: "⥐")
    click_button 'edit_post'
    expect(page.first("blockquote footer").text).to eq("The Basileus")
  end

end