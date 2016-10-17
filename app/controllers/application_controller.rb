class ApplicationController < Controller

	get '/' do 
		erb :index
	end

	get '/C11P' do 
		erb :C11P
	end

end