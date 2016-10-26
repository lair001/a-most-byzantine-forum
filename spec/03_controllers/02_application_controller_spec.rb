require 'sinatra_helper'
# require 'controllers_spec_helper'

describe 'ApplicationController' do

	before do

	end

  	describe "get '#{root_path}'" do

	  it 'loads the homepage' do
	    get root_path
		expect(last_response.status).to eq(200)
		expect(last_request.path).to eq("/")
      	expect_path(:root)
	  end

	end

	describe "get '#{tribute_path}'" do

	  it 'loads a tribute page' do
	    get tribute_path
		expect(last_response.status).to eq(200)
		expect_path(:tribute)
	  end

	end

end