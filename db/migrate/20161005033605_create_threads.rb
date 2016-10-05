class CreateThreads < ActiveRecord::Migration
  def change
  	create_table :threads do |t| 
  		t.string :title
  		t.timestamps
  	end
  end
end
