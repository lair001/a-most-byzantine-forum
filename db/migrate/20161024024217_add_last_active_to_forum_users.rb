class AddLastActiveToForumUsers < ActiveRecord::Migration
  def change
  	add_column :forum_users, :last_active, :datetime
  end
end
