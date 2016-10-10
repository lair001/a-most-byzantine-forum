require 'spec_helper'

describe 'forum_users/create' do

  before do

  end

  it 'renders a signup form' do 
  	visit '/forum_users/new'
  	expect(page).to have_css('form[method="post"][action="/forum_users"]')
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_user[username]')
  	expect(page).to have_field('forum_user[email]')
  	expect(page).to have_field('forum_user[password]')
  end


end