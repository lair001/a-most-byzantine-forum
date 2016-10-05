class CreateForumThreads < ActiveRecord::Migration
  def change
  	create_table :forum_threads do |t| 
  		t.string :title
  		t.timestamps
  	end
  end
end
