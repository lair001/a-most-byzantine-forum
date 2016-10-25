
module RouteHelper

	def current_route
		@current_route ||= request.path_info
	end

	def cached_route_or_home
		params[:cached_route].nil? ? redirect(root_path) : redirect("#{params[:cached_route]}")
	end

	def root_path
		"/"
	end

	def tribute_path
		"/C11P"
	end

end