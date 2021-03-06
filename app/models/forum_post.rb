class ForumPost < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Slugifiable::InstanceMethods
	include Currentable::InstanceMethods

	extend Slugifiable::ClassMethods

	belongs_to :forum_user
	belongs_to :forum_thread

	validates :content, length: { in: 2..2000 }
	validates :forum_user, presence: true
	validates :forum_thread, presence: true

	validate do
		presence_of_unique_slug
		absence_of_forbidden_characters_in :content
	end

	after_destroy :update_current_user_activity

	after_create :update_creating_user_activity
	after_create :update_thread_after_post_creation

	after_update :update_current_user_activity
	after_update :update_thread_after_post_update

	def slug
		@slug ||= self.build_slug
	end

	def build_slug
		@slug = ""
		@slug += self.forum_user_slug + "_" if self.forum_user && self.forum_user_slug
		@slug += self.forum_thread_slug + "_" if self.forum_thread && self.forum_thread_slug
		@slug += self.slugify(:content)[0, 200] if self.content
	end

	def forum_user_slug
		@forum_user_slug ||= self.forum_user.slug
	end

	def forum_user_username
		@forum_user_username ||= self.forum_user.username
	end

	def forum_user_title
		@forum_user_title ||= self.forum_user.title
	end

	def forum_user_last_active
		@forum_user_last_active ||= self.forum_user.last_active
	end

	def forum_thread_slug
		@forum_thread_slug ||= self.forum_thread.slug
	end

	def forum_thread_title
		@forum_thread_title ||= self.forum_thread.title
	end

private

	def update_creating_user_activity
		self.forum_user.update(last_active: Time.now)
	end

	def update_thread_after_post_creation
		self.forum_thread.update(updated_at: Time.now) if self.forum_thread.forum_posts.count > 1
	end

	def update_thread_after_post_update
		self.forum_thread.update(updated_at: Time.now)
	end

end
