module PathsHelper

	module ForumPosts

		def forum_posts_path
			"/forum_posts"
		end

		def new_forum_post_path
			"#{forum_posts_path}/new"
		end

		def forum_post_path(post = nil)
			"#{forum_posts_path}/#{post ? post.slug : ":slug"}"
		end

		def edit_forum_post_path(post = nil)
			"#{forum_post_path(post)}/edit"
		end

		def new_forum_thread_forum_post_path(thread = nil, post = nil)
			"#{forum_thread_path(thread).gsub("/:slug", "/:forum_thread_slug")}#{new_forum_post_path}"
		end

		def edit_forum_thread_forum_post_path(thread = nil, post = nil)
			"#{forum_thread_path(thread).gsub("/:slug", "/:forum_thread_slug")}#{edit_forum_post_path(post)}"
		end

	end

end