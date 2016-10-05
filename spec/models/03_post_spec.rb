require 'spec_helper'

describe 'Post' do 

  before do
    @user = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @thread = ForumThread.create(title: "nothing here")
    @post1 = ForumPost.create(content: "ipsum lorem", user_id: @user.id, thread_id: @thread.id)
    @post2 = ForumPost.create(content: "blah blah", user_id: @user.id, thread_id: @thread.id)
  end

  it 'knows its content' do 
    expect(@post1.content).to eq("ipsum lorem")
    expect(@post2.content).to eq("blah blah")
  end

  it 'knows when it was created' do 
    expect(@post1.created_at).to be_a(DateTime)
    expect(@post2.created_at).to be_a(DateTime)
  end

  it 'knows when it was last updated' do 
    expect(@post1.updated_at).to be_a(DateTime)
    expect(@post2.updated_at).to be_a(DateTime)
  end

  it 'belongs to a user' do 
    expect(@post1.user).to eq(@user)
    expect(@post2.user).to eq(@user)
  end

  it 'belongs to a thread' do 
    expect(@post1.thread).to eq(@thread)
    expect(@post2.thread).to eq(@thread)
  end

end