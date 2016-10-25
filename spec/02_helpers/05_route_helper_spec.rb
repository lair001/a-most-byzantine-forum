require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'RoutesHelper' do

	before do
		@helper1 = Helper.new
	end


	describe '#current_route' do

		it 'returns the current route' do
			@helper1.request.path_info = '/'
			expect(@helper1.current_route).to eq('/')
		end

	end

	describe '#cached_route_or_home' do

		it 'redirects to a cached path if set or home if there is no cached path' do 
			expect(@helper1.cached_route_or_home).to eq('/')
			@helper1.params[:cached_route] = '/threads'
			expect(@helper1.cached_route_or_home).to eq('/threads')
		end

	end

end