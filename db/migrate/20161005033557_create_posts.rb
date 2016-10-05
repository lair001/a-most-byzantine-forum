class CreateForumPosts < ActiveRecord::Migration
  def change
  	create_table :forum_posts do 
  		t.string :content 
  		t.integer :user_id 
  		t.integer :thread_id
  		t.timestamps
  	end
  end
end
