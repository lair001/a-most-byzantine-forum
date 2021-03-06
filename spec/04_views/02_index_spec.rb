require 'sinatra_helper'
# require 'views_spec_helper'

describe 'index' do

  before do
  	@user1 = ForumUser.create(username: "val", email: "val@val.com", password: "val", moderator: true, administrator: true)
  end

  it 'displays links to sign up and login if not logged in' do
  	visit helper.root_path
    expect(page).to have_link('Sign Up', href: '/forum_users/new')
    expect(page).to have_link('Log In', href: helper.login_path)
    expect(page).to have_no_link('View Threads', href: '/forum_threads')
  end

  it 'displays links to view threads if logged in' do 
    use_view_to_login_as(@user1)
  	visit helper.root_path
    expect(page).to have_link('View Threads', href: '/forum_threads')
    expect(page).to have_no_link('Sign Up', href: '/forum_users/new')
    expect(page).to have_no_link('Log In', href: helper.login_path)
  end

end