require 'spec_helper'

describe 'Controller' do 

  before do

  end

  it 'knows about sessions' do
    get '/'
    session = {}
    session[:user_id] = 1
    get '/C9P'
    expect(session[:user_id]).to eq(1)
  end

end