module ForumThreadsHelper

	def sort_threads
		@threads ||= ForumThread.order(updated_at: :desc)
	end

end