class CreateForumPosts < ActiveRecord::Migration
  def change
  	create_table :forum_posts do |t|
  		t.string :content 
  		t.integer :forum_user_id 
  		t.integer :forum_thread_id
  		t.timestamps null: false
  	end
  end
end
