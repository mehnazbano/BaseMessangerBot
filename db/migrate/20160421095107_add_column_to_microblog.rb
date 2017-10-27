class AddColumnToMicroblog < ActiveRecord::Migration
  def change
  	add_column :microblogs, :community_id, :integer
  	add_column :microblogs, :type, :integer
  	add_column :microblogs, :status, :integer
  end
end
