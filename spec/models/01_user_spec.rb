require 'spec_helper'

describe 'User' do 

  before do
    @user1 = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @user2 = ForumUser.create(username: "Top Gun", email: "tops@aol.com", password: "thebest", moderator: true, administrator: true)
    @user3 = ForumUser.create(username: "billy bob", email: "bb@gmail.com", password: "bobs")
    @user4 = ForumUser.create(username: "BiLlY BoB", email: "hackzor@gmail.com", password: "1337")
  end
  it 'can slug the username' do
    expect(@user1.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user1.slug
    expect(ForumUser.find_by_slug(slug).username).to eq("test 123")
  end

  it 'can validate by slug' do 
    expect(ForumUser.validate_by_slug(@user3)).to eq(false)
    expect(ForumUser.validate_by_slug(@user4)).to eq(false)
    expect(ForumUser.validate_by_slug(@user1)).to eq(true)
  end

  it 'has a secure password' do
    expect(@user1.authenticate("dog")).to eq(false)
    expect(@user1.authenticate("test")).to eq(@user1)
  end

  it 'validates for the presence of username, email, and password' do 
    expect(ForumUser.new.save).to eq(false)
    expect(ForumUser.new(username: "I Can Read").save).to eq(false)
    expect(ForumUser.new(email: "123@abc.com").save).to eq(false)
    expect(ForumUser.new(password: "abc123").save).to eq(false)
    expect(ForumUser.new(email: "123@abc.com", password: "abc123").save).to eq(false)
    expect(ForumUser.new(username: "I Can Read", password: "abc123").save).to eq(false)
    expect(ForumUser.new(username: "I Can Read", email: "123@abc.com").save).to eq(false)
    expect(ForumUser.new(username: "I Can Read", email: "123@abc.com", password: "abc123").save).to eq(true)
  end

  it 'knows whether it is a moderator' do 
    expect(@user1.moderator).to eq(false)
    expect(@user2.moderator).to eq(true)
  end

  it 'is not a moderator by default' do 
    expect(@user3.moderator).to eq(false)
  end

  it 'knows whether it is an administrator' do 
    expect(@user1.administrator).to eq(false)
    expect(@user2.administrator).to eq(true)
  end

  it 'is not an administrator by default' do 
    expect(@user3.administrator).to eq(false)
  end

  it 'knows when it was created' do 
    expect(@user1.created_at).to be_a(Time)
  end

  it 'knows when it was last updated' do 
    expect(@user1.updated_at).to be_a(Time)
  end

  it 'has many threads through posts' do 
    @thread1 = ForumThread.create(title: "nothing here")
    @thread2 = ForumThread.create(title: "hello there")
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user1.id, forum_thread_id: @thread1.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user1.id, forum_thread_id: @thread2.id)
    expect(@user1.forum_posts).to include(@post1)
    expect(@user1.forum_posts).to include(@post2)
    expect(@user1.forum_threads).to include(@thread1)
    expect(@user1.forum_threads).to include(@thread2)
  end

end