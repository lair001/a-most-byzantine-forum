module ApplicationHelper

	def current_route
		@current_route ||= request.path_info
	end

	def format_time(time)
		time.strftime("%Y/%m/%d %H:%M:%S")
	end

	def set_attributes(model, attr_hash, settable_attr_array)
		settable_attr_array.each do |attr|
			model.send("#{attr}=", attr_hash[attr.to_sym]) if !attr_hash[attr.to_sym].nil? && attr_hash[attr.to_sym] != ""
		end
	end

	def set_and_save_attributes(model, attr_hash, settable_attr_array)
		set_attributes(model, attr_hash, settable_attr_array)
		model.save
	end

	def cached_route_or_home
		params[:cached_route].nil? ? redirect('/') : redirect("#{params[:cached_route]}")
	end

	def trim_whitespace(hash, keys_whose_values_will_be_trimmed_array)
		keys_whose_values_will_be_trimmed_array.each do |key|
			hash[key] = hash[key].strip.gsub(/(?<foo>(\s|\u00A0|\u2003))( |\u00A0)/, '\k<foo>'  ).gsub(/( |\u00A0)(?<foo>(\s|\u00A0|\u2003))/, '\k<foo>') if hash[key].is_a?(String)
		end
		hash
	end

	def whitespace_as_html(string)
		string.gsub(/\t/, "&emsp;&emsp;").gsub(/\u2003/, "&emsp;").gsub(/\r\n/, "<br>").gsub(/[\f\n\r]/, "<br>").gsub(/\v/, "<br><br>")
	end

end