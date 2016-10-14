require 'spec_helper'

describe 'ForumThread' do 

  before do
    @thread1 = ForumThread.create(title: "test 123")
    @thread2 = ForumThread.create(title: "Wow, Bob")
  end

  it 'can slug the title' do
    expect(@thread1.slug).to eq("test-123")
  end

  it 'can find a thread based on the slug' do
    slug = @thread1.slug
    expect(ForumThread.find_by_slug(slug).title).to eq("test 123")
  end

  it 'knows when it was created' do 
    expect(@thread1.created_at).to be_a(Time)
  end

  it 'knows when it was last updated' do 
    expect(@thread1.updated_at).to be_a(Time)
  end

  it 'validates for the presence of title' do 
    expect(ForumThread.new.save).to eq(false)
    expect(ForumThread.new(title: "Where am I?").save).to eq(true)
  end

  it 'validates for the uniqueness of its slug' do 
    expect(ForumThread.new(title: "tEsT-123").save).to eq(false)
    expect(ForumThread.new(title: "I Can Read Good").save).to eq(true)
  end

    it 'validates that the only whitespace in its title is space' do 
    expect(ForumThread.new(title: "The\vGreat Schism").save).to eq(false)
    expect(ForumThread.new(title: "The Great\tSchism").save).to eq(false)
    expect(ForumThread.new(title: "The Great Schism").save).to eq(true)
  end

  it 'validates for the absence of forbidden characters in its title' do 
    expect(ForumThread.new(title: "The⚒Great⚓Schism").save).to eq(false)
    expect(ForumThread.new(title: "The-Great Schism").save).to eq(true)
  end

  it 'has many users through posts' do 
    @user1 = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @user2 = ForumUser.create(username: "igor", email: "igor@aol.com", password: "yumyum", moderator: false, administrator: false)
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user1.id, forum_thread_id: @thread1.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user2.id, forum_thread_id: @thread1.id)
    expect(@thread1.forum_posts).to include(@post1)
    expect(@thread1.forum_posts).to include(@post2)
    expect(@thread1.forum_users).to include(@user1)
    expect(@thread1.forum_users).to include(@user2)
  end

end