class AddBannedToForumUsers < ActiveRecord::Migration
  def change
  	add_column :forum_users, :banned, :boolean, default: false
  end
end
