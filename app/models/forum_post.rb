class ForumPost < ActiveRecord::Base

	include Forbiddable::InstanceMethods

	belongs_to :forum_user
	belongs_to :forum_thread

	validates :content, presence: true
	validates :forum_user_id, presence: true
	validates :forum_thread_id, presence: true

	validate do
		absence_of_forbidden_characters_in :content
	end

end
