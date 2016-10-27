module PagesHelper

	module Titles

		def project_title
			"A Most Byzantine Forum"
		end

		def root_page_title
			"A Most Byzantine Forum"
		end

		def tribute_page_title
			"Constantine XI Palaiologos"
		end

		def forum_threads_page_title
			"Threads"
		end

		def forum_thread_page_title
			@thread.title
		end

		def forum_users_page_title
			"Users"
		end

		def forum_user_page_title
			@user.username
		end

		def new_forum_thread_forum_post_page_title
			"Posting to Thread:"
		end

	end

end