class ApplicationController < Controller

	get root_path do 
		erb :'index.html'
	end

	get tribute_path do 
		erb :'C11P.html'
	end

end