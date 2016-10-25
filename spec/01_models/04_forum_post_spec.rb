require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'ForumPost' do 

  before do
    @user = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @thread = ForumThread.create(title: "nothing here")
    @post1 = ForumPost.create(content: "ipsum lorem", forum_user_id: @user.id, forum_thread_id: @thread.id)
    @post2 = ForumPost.create(content: "blah blah", forum_user_id: @user.id, forum_thread_id: @thread.id)

    @helper1 = Helper.new
  end

  it 'knows its content' do 
    expect(@post1.content).to eq("ipsum lorem")
    expect(@post2.content).to eq("blah blah")
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

  it "updates the activity of the user that created it" do
    @initial_activity = @user.last_active
    ForumPost.create(content: "nothing about nothing", forum_user_id: @user.id, forum_thread_id: @thread.id)
    @user = ForumUser.find(@user.id)
    expect(@user.last_active <=> @initial_activity).to eq(1)

    @initial_activity = @user.last_active
    ForumPost.new(content: "nothing about something", forum_user_id: @user.id, forum_thread_id: @thread.id).save
    @user = ForumUser.find(@user.id)
    expect(@user.last_active <=> @initial_activity).to eq(1)
  end

  it 'knows when it was last updated' do 
    expect(@post1.updated_at).to be_a(Time)
    expect(@post2.updated_at).to be_a(Time)
  end

  it "updates the current user's activity when told about the current user and edited" do
    @helper1.session = { forum_user_id: @user.id }
    @initial_activity = @helper1.current_user.last_active
    @post1.tell_about_current_user_and_update(@helper1.current_user, content: "ipsum lorem and more ipsum lorem")
    expect(@helper1.current_user.last_active <=> @initial_activity).to eq(1)

    @initial_activity = @helper1.current_user.last_active
    params = { "forum_post" => { content: "where be my lorem?" } }
    params["forum_post"]["current_user"] = @helper1.current_user
    @helper1.set_and_save_attributes(@post1, @helper1.trim_whitespace(params["forum_post"], ["content"]), ["content", "current_user"])
    expect(@helper1.current_user.last_active <=> @initial_activity).to eq(1)
  end

  it "updates the current user's activity when told about the current user and destroyed" do
    @helper1.session = { forum_user_id: @user.id }
    @initial_activity = @helper1.current_user.last_active
    @post1.tell_about_current_user_and_destroy(@helper1.current_user)
    expect{ForumPost.find(@post1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(@helper1.current_user.last_active <=> @initial_activity).to eq(1)
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