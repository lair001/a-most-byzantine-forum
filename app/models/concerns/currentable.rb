module Currentable

	module InstanceMethods

		attr_reader :current_user

		# after_update :update_current_user_activity

		def current_user=(current_user)
			@current_user ||= current_user
		end

		# def tell_about_current_user_and_update(current_user, update_hash)
		# 	self.current_user = current_user
		# 	self.update(update_hash)
		# end

		# def tell_about_current_user_and_destroy(current_user)
		# 	self.current_user = current_user
		# 	self.destroy
		# end

	private

		def update_current_user_activity
			self.current_user.update(last_active: Time.now) if self.current_user
		end

	end

end