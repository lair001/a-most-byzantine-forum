module PagesHelper

	module Taglines

		def root_page_tagline
			"Chat About All Things Roman"
		end

		def tribute_page_tagline
			"The Last Roman Emperor"
		end

		def forum_threads_page_tagline
			"Spread rumors about your friends and enemies!"
		end

		def forum_users_page_tagline
			"Your Rivals in the Basileus's Court"
		end

		def login_page_tagline
			"Welcome back! Please login to join the intrigue!"
		end

		def new_forum_user_page_tagline
			"Enroll in the Basileus's Court!"
		end

		def forum_user_page_tagline
			@user.title
		end

		def edit_forum_user_tagline
			"Editing User: #{@user.username}"
		end

		def new_forum_thread_tagline
			"Create a New Thread!"
		end

		def edit_forum_thread_tagline
			"Editing Thread: #{@thread.title}"
		end

		def new_forum_thread_forum_post_page_tagline
			@thread.title
		end

		def edit_forum_thread_forum_post_page_tagline
			"Editing Post ##{@post.id}"
		end

	end

end