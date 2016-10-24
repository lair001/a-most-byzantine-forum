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

	before_create :set_creating_user_activity

	after_update :update_current_user_activity

private

	def set_creating_user_activity
		self.forum_user.last_active = Time.now
	end

end
