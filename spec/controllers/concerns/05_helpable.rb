require 'spec_helper'

describe 'Helpable' do 

  before do 

    @helpers = Helpers.new

  end

  describe '#logged_in?' do

    it 'returns whether the user is logged in' do
      session = {}
      expect(@helpers.logged_in?).to eq(false)
      session[:user_id] = 1
      expect(@helpers.logged_in?).to eq(true)
    end

  end


end