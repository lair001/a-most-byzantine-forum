class ApplicationController < Controller

	get '/' do 
		erb :index
	end

	get '/k9p' do 
		erb :k9p
	end

end