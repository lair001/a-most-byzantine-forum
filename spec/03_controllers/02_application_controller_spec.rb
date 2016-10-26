require 'sinatra_helper'
# require 'controllers_spec_helper'

describe 'ApplicationController' do

	before do

	end

  	describe "get '/'" do

	  it 'loads the homepage' do
	    get '/'
		expect(last_response.status).to eq(200)
		expect(last_request.path).to eq("/")
      	expect_path(:root)
	  end

	end

	describe "get '/C11P'" do

	  it 'loads a tribute page' do
	    get '/C11P'
		expect(last_response.status).to eq(200)
		expect_path(:tribute)
	  end

	end

end