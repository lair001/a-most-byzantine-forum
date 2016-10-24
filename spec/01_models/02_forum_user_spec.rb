require 'spec_helper'
require 'helpers_helper'

describe 'ForumUser' do 

  before do
    @user1 = ForumUser.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
    @user2 = ForumUser.create(username: "Top Gun", email: "tops@aol.com", password: "thebest", moderator: true, administrator: true)
    @user3 = ForumUser.create(username: "billy bob", email: "bb@gmail.com", password: "bobs", banned: false)
    @user4 = ForumUser.create(username: "hackzor", email: "hackzor@gmail.com", password: "1337", banned: true)
    @user5 = ForumUser.create(username: "sal", email: "sal@sal.com", password: "sal", moderator: true)
    @user6 = ForumUser.create(username: "wal", email: "wal@wal.com", password: "wal", administrator: true)

    @helper1 = Helper.new
  end
  
  it 'can slug the username' do
    expect(@user1.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user1.slug
    expect(ForumUser.find_by_slug(slug).username).to eq("test 123")
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

  it 'validates for the uniqueness of its slug' do 
    expect(ForumUser.new(username: "tOP-gUn", email: "123@abc.com", password: "abc123").save).to eq(false)
    expect(ForumUser.new(username: "I Can Read", email: "123@abc.com", password: "abc123").save).to eq(true)
  end

  it 'validates for the absence of forbidden characters in its username' do 
    expect(ForumUser.new(username: "peter⚔webs", email: "peter@peter.com", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter").save).to eq(true)
  end

  it 'validates for the absence of forbidden characters in its password' do 
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter⚔great").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter_great").save).to eq(true)
  end

  it 'validates that the only space in its username is whitespace' do 
    expect(ForumUser.new(username: "peter\rwebs", email: "peter@peter.com", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter…webs", email: "peter@peter.com", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter webs", email: "peter@peter.com", password: "peter").save).to eq(true)
  end

  it 'validates for the absence of whitespace in its email' do 
    expect(ForumUser.new(username: "peter_webs", email: "peter@ peter.com", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter").save).to eq(true)
  end

  it 'validates its email for proper format' do 
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com123", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "pet.er@peter.com", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter..", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.", password: "peter").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter").save).to eq(true)
  end

  it 'validates for the absence of whitespace in its password' do 
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "\rpeter pan\t").save).to eq(false)
    expect(ForumUser.new(username: "peter_webs", email: "peter@peter.com", password: "peter").save).to eq(true)
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

  it 'knows when it was last active' do
    expect(@user1.last_active).to be_a(Time)
  end

  it "updates the current user's activity when told about the current user and updated" do
    @helper1.session = { forum_user_id: @user6.id }
    @initial_activity = @helper1.current_user.last_active
    @user5.tell_about_current_user_and_update(@helper1.current_user, username: "sally")
    expect(@helper1.current_user.last_active <=> @initial_activity).to eq(1)

    @initial_activity = @helper1.current_user.last_active
    params = { "forum_user" => { username: "sally" } }
    params["forum_user"]["current_user"] = @helper1.current_user
    @helper1.set_and_save_attributes(@user5, @helper1.trim_whitespace(params["forum_user"], ["username"]), ["username", "email", "password", "current_user"])
    expect(@helper1.current_user.last_active <=> @initial_activity).to eq(1)
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

  it 'knows whether it has been banned' do 
    expect(@user3.banned).to eq(false)
    expect(@user4.banned).to eq(true)
  end

  it 'is not banned by default' do 
    expect(@user1.banned).to eq(false)
  end

  it "knows its title" do 
    expect(@user4.title).to eq("Banned")
    expect(@user2.title).to eq("Superuser")
    expect(@user6.title).to eq("Administrator")
    expect(@user5.title).to eq("Moderator")
    expect(@user1.title).to eq("Courtier")
  end

end