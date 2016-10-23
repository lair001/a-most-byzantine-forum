require 'spec_helper'

describe 'ForumPost' do 

  before do
    @user = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @thread = ForumThread.create(title: "nothing here")
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user.id, forum_thread_id: @thread.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user.id, forum_thread_id: @thread.id)
  end

  it 'knows its content' do 
    expect(@post1.content).to eq("ipsum lorem")
    expect(@post2.content).to eq("blah blah")
  end

  it 'can convert its content into html' do 
    @post3 = ForumPost.create(content: "ipsum|\t|\u2003|\r\n|\f|\n|\r|\v|lorem")
    expect(@post3.content_as_html).to eq("ipsum|&emsp;&emsp;|&emsp;|<br>|<br>|<br>|<br>|<br><br>|lorem")
  end

  it 'validates for the presence of content, user, and thread' do 
    expect(ForumPost.new.save).to eq(false)
    expect(ForumPost.new(content: "Ipsum lorem is so cool!!!").save).to eq(false)
    expect(ForumPost.new(forum_user: @user).save).to eq(false)
    expect(ForumPost.new(forum_thread: @thread).save).to eq(false)
    expect(ForumPost.new(content: "Ipsum lorem is so cool!!!", forum_user: @user).save).to eq(false)
    expect(ForumPost.new(content: "Ipsum lorem is so cool!!!", forum_thread: @thread).save).to eq(false)
    expect(ForumPost.new(forum_user: @user, forum_thread: @thread).save).to eq(false)
    expect(ForumPost.new(content: "Ipsum lorem is so cool!!!", forum_user: @user, forum_thread: @thread).save).to eq(true)
  end

  it 'knows when it was created' do 
    expect(@post1.created_at).to be_a(Time)
    expect(@post2.created_at).to be_a(Time)
  end

  it 'knows when it was last updated' do 
    expect(@post1.updated_at).to be_a(Time)
    expect(@post2.updated_at).to be_a(Time)
  end

  it 'belongs to a user' do 
    expect(@post1.forum_user).to eq(@user)
    expect(@post2.forum_user).to eq(@user)
  end

  it 'belongs to a thread' do 
    expect(@post1.forum_thread).to eq(@thread)
    expect(@post2.forum_thread).to eq(@thread)
  end

  it 'validates for the absence of forbidden characters in its title' do 
    expect(ForumPost.new(content: "The⚖rain⚕in⚗Spain⚘is⚙quite✀drenching.", forum_user_id: @user.id, forum_thread_id: @thread.id).save).to eq(false)
    expect(ForumPost.new(content: "The rain in Spain is quite drenching.", forum_user_id: @user.id, forum_thread_id: @thread.id).save).to eq(true)
  end

end