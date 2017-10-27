class AddTypeToBlogpost < ActiveRecord::Migration
  def change
  	add_column :blogposts, :type, :integer
  end
end
