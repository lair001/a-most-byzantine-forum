require 'spec_helper'
require 'controllers_helper'

describe 'ApplicationController' do 

  before do

  end

  	describe "get '/'" do

	  it 'loads the homepage' do
	    get '/'
		expect(last_response.status).to eq(200)
		expect(last_request.path).to eq("/")
      	expect(last_response.body).to include("Chat About All Things Roman")
	  end

	end

	describe "get '/C11P'" do

	  it 'loads a tribute page' do
	    get '/C11P'
		expect(last_response.status).to eq(200)
		expect(last_request.path).to eq("/C11P")
      	expect(last_response.body).to include("Constantine XI Palaiologos")
	  end

	end

end