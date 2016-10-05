require 'spec_helper'

describe 'User' do 

  before do
    @user = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(ForumUser.find_by_slug(slug).username).to eq("test 123")
  end

  it 'has a secure password' do
    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("test")).to eq(@user)
  end

  it 'knows whether it is a moderator' do 
    expect(@user.moderator).to eq(false)
  end

  it 'knows whether it is an administrator' do 
    expect(@user.administrator).to eq(false)
  end

  it 'knows when it was created' do 
    expect(@user.created_at).to be_a(DateTime)
  end

  it 'knows when it was last updated' do 
    expect(@user.updated_at).to be_a(DateTime)
  end

  it 'has many threads through posts' do 
    @thread1 = ForumThread.create(title: "nothing here")
    @thread2 = ForumThread.create(title: "hello there")
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user.id, forum_thread_id: @thread1.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user.id, forum_thread_id: @thread2.id)
    expect(@user.forum_posts).to include(@post1)
    expect(@user.forum_posts).to include(@post2)
    expect(@user.forum_threads).to include(@thread1)
    expect(@user.forum_threads).to include(@thread2)
  end

end