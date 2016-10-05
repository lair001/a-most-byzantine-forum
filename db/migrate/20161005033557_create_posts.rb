class CreatePosts < ActiveRecord::Migration
  def change
  	create_table :posts do 
  		t.string :content 
  		t.integer :user_id 
  		t.integer :thread_id
  		t.timestamps
  	end
  end
end
