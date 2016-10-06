class CreateForumUsers < ActiveRecord::Migration
  def change
  	create_table :forum_users do |t|
  		t.string :username
  		t.string :email 
  		t.string :password_digest
  		t.boolean :moderator, default: false
  		t.boolean :administrator, default: false
  		t.timestamps null: false
  	end
  end
end
