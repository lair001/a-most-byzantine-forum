module Helpable

	def logged_in?
		!!session[:forum_user_id]
	end

	def current_user
		@current_user ||= ForumUser.find(session[:forum_user_id])
	end

	def sort_user_posts(user)
		@user_posts ||= user.forum_posts.order(updated_at: :desc)
	end

	def moderator?
		@moderator ||= current_user.moderator
	end

	def administrator?
		@administrator ||= current_user.administrator
	end

	def current_route
		@current_route ||= request.path_info
	end

	def sort_threads
		@threads ||= ForumThread.order(updated_at: :desc)
	end

	def sort_users
		@users ||= ForumUser.order(username: :asc)
	end

	def sort_thread_posts
		@thread_posts ||= @thread.forum_posts.order(created_at: :asc)
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

end