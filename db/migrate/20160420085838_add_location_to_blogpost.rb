class AddLocationToBlogpost < ActiveRecord::Migration
  def change
  	add_column :blogposts, :location, :integer
  end
end
