class ForumPost < ActiveRecord::Base

	belongs_to :forum_user 
	belongs_to :forum_thread

end
