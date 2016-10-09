require 'spec_helper'

describe 'ApplicationController' do 

  before do

  end

  	describe "get '/'" do

	  it 'loads the homepage' do
	    get '/'
		expect(last_response.status).to eq(200)
      	expect(last_response.body).to include("A Most Byzantine Forum")
	  end

	end

	describe "get '/C9P'" do

	  it 'loads a tribute page' do
	    get '/C9P'
		expect(last_response.status).to eq(200)
      	expect(last_response.body).to include("Constantine XI Palaiologos")
	  end

	end

end