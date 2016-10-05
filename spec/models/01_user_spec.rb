require 'spec_helper'

describe 'User' do 
  before do
    @user = User.create(username: "test 123", email: "test123@aol.com", password: "test", moderator: false, administrator: false)
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("test 123")
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
end