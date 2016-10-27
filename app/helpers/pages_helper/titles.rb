module PagesHelper

	module Titles

		def project_page_title
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

	end

end