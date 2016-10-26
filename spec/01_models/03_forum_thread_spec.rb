require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'ForumThread' do 

  before do
    @user3 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true)

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

  it "updates the current user's activity when told about the current user and updated" do
    helper.session = { forum_user_id: @user3.id }
    @initial_activity = helper.current_user.last_active
    helper.tell_model_about_current_user_and_update(@thread1, title: "Spam")
    expect(helper.current_user.last_active <=> @initial_activity).to eq(1)

    @initial_activity = helper.current_user.last_active
    params = { "forum_thread" => { title: "Spam and more spam" } }
    params["forum_thread"]["current_user"] = helper.current_user
    helper.set_and_save_attributes(@thread1, helper.trim_whitespace(params["forum_thread"], ["title"]), ["title", "current_user"])
    expect(helper.current_user.last_active <=> @initial_activity).to eq(1)
  end

  it "updates the current user's activity when told about the current user and destroyed" do
    helper.session = { forum_user_id: @user3.id }
    @initial_activity = helper.current_user.last_active
    helper.tell_model_about_current_user_and_destroy(@thread1)
    expect{ForumThread.find(@thread1.id)}.to raise_error(ActiveRecord::RecordNotFound)
    expect(helper.current_user.last_active <=> @initial_activity).to eq(1)
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