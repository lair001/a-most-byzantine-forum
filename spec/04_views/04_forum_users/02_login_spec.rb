require 'sinatra_helper'
require 'views_spec_helper'

describe 'forum_users/login' do

  before do

  end

  it 'renders a login form' do 
  	visit '/login'
  	expect(page).to have_css('form[method="post"][action="/login"]')
    expect(page).to have_no_field("_method")
  	expect(page).to have_css('button[type="submit"]')
  	expect(page).to have_field('forum_user[username]')
  	expect(page).to have_no_field('forum_user[email]')
  	expect(page).to have_field('forum_user[password]')
  end

  it 'shows errors if login is unsuccessful' do
    visit '/login'
    click_button 'login'
    expect(page.first("blockquote footer").text).to eq("The Basileus")
  end


end