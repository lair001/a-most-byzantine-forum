class ForumPost < ActiveRecord::Base

	include Forbiddable::InstanceMethods

	belongs_to :forum_user
	belongs_to :forum_thread

	validates :content, length: { in: 3..1000 }
	validates :forum_user_id, presence: true
	validates :forum_thread_id, presence: true

	validate do
		absence_of_forbidden_characters_in :content
	end

	def content_as_html
		self.content.gsub(/\t/, "&emsp;&emsp;").gsub(/\u2003/, "&emsp;").gsub(/\r\n/, "<br>").gsub(/[\f\n\r]/, "<br>").gsub(/\v/, "<br><br>")
	end

end
