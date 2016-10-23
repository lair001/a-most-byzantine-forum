class ApplicationController < Controller

	get '/' do 
		erb :'index.html'
	end

	get '/C11P' do 
		erb :'C11P.html'
	end

end