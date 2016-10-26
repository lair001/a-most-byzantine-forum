module PathsHelper

	module ForumThreads

		def forum_threads_path
			"/forum_threads"
		end

		def forum_thread_path(thread = nil)
			"#{forum_threads_path}/#{thread ? thread.slug : ":slug"}"
		end

		def new_forum_thread_path
			"#{forum_threads_path}/new"
		end

		def edit_forum_thread_path(thread = nil)
			"#{forum_thread_path(thread)}/edit"
		end

		def search_forum_threads_path
			"#{forum_threads_path}/search"
		end

	end

end