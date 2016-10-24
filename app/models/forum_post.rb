class ForumPost < ActiveRecord::Base

	include Forbiddable::InstanceMethods
	include Currentable::InstanceMethods

	belongs_to :forum_user
	belongs_to :forum_thread

	validates :content, length: { in: 2..2000 }
	validates :forum_user_id, presence: true
	validates :forum_thread_id, presence: true

	validate do
		absence_of_forbidden_characters_in :content
	end

	after_create :update_creating_user_activity
	after_create :update_thread_after_post_creation

	after_update :update_current_user_activity
	after_update :update_thread_after_post_update

private

	def update_creating_user_activity
		self.forum_user.update(last_active: Time.now)
	end

	def update_thread_after_creation
		self.forum_thread.update(updated_at: Time.now) if self.forum_thread.posts.count > 1
	end

	def update_thread_after_post_update
		self.forum_thread.update(updated_at: Time.now)
	end

end
