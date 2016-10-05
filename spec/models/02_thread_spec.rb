require 'spec_helper'

describe 'Thread' do 

  before do
    @thread = ForumThread.create(title: "test 123")
  end

  it 'can slug the title' do
    expect(@thread.slug).to eq("test-123")
  end

  it 'can find a thread based on the slug' do
    slug = @thread.slug
    expect(ForumThread.find_by_slug(slug).title).to eq("test 123")
  end

  it 'knows when it was created' do 
    expect(@user.created_at).to be_a(DateTime)
  end

  it 'knows when it was last updated' do 
    expect(@user.updated_at).to be_a(DateTime)
  end

  it 'has many users through posts' do 
    @user1 = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @user2 = ForumUser.create(username: "igor", email: "igor@aol.com", password: "yumyum", moderator: false, administrator: false)
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user1.id, forum_thread_id: @thread.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user2.id, forum_thread_id: @thread.id)
    expect(@thread.forum_posts).to include(@post1)
    expect(@thread.forum_posts).to include(@post2)
    expect(@thread.forum_users).to include(@user1)
    expect(@thread.forum_users).to include(@user2)
  end

end