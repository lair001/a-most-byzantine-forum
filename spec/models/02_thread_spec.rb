require 'spec_helper'

describe 'Thread' do 

  before do
    @thread = Byzantine::Thread.create(title: "test 123")
  end

  it 'can slug the title' do
    expect(@thread.slug).to eq("test-123")
  end

  it 'can find a thread based on the slug' do
    slug = @thread.slug
    expect(Byzantine::Thread.find_by_slug(slug).title).to eq("test 123")
  end

  it 'knows when it was created' do 
    expect(@user.created_at).to be_a(DateTime)
  end

  it 'knows when it was last updated' do 
    expect(@user.updated_at).to be_a(DateTime)
  end

  it 'has many users through posts' do 
    @user1 = Byzantine::User.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @user2 = Byzantine::User.create(username: "igor", email: "igor@aol.com", password: "yumyum", moderator: false, administrator: false)
    @post1 = Byzantine::Post.create(content: "ipsum lorem", user_id: @user1.id, thread_id: @thread.id)
    @post2 = Byzantine::Post.create(content: "blah blah", user_id: @user2.id, thread_id: @thread.id)
    expect(@thread.posts).to be_a(Array)
    expect(@thread.posts).to include(@post1)
    expect(@thread.posts).to include(@post2)
    expect(@thread.users).to be_a(Array)
    expect(@thread.users).to include(@user1)
    expect(@thread.users).to include(@user2)
  end

end