class ApplicationController < Controller

	get '/' do 
		erb :index
	end

	get '/C9P' do 
		erb :C9P
	end

end