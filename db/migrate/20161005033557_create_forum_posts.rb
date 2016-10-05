class CreateForumPosts < ActiveRecord::Migration
  def change
  	create_table :forum_posts do |t|
  		t.string :content 
  		t.integer :user_id 
  		t.integer :thread_id
  		t.timestamps null: false
  	end
  end
end
