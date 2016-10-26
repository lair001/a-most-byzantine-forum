require 'sinatra_helper'
# require 'helpers_spec_helper'

describe 'RoutesHelper' do

	before do

	end


	describe '#current_route' do

		it 'returns the current route' do
			helper.request.path_info = '/'
			expect(helper.current_route).to eq('/')
		end

	end

	describe '#cached_route_or_home' do

		it 'redirects to a cached path if set or home if there is no cached path' do 
			expect(helper.cached_route_or_home).to eq('/')
			helper.params[:cached_route] = '/threads'
			expect(helper.cached_route_or_home).to eq('/threads')
		end

	end

end