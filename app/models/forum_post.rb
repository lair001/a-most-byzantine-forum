class ForumPost < ActiveRecord::Base

	belongs_to :forum_user 
	belongs_to :forum_thread

	validates :content, presence: true
	validates :forum_user_id, presence: true
	validates :forum_thread_id, presence: true

end
