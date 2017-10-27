class AddTagsToBlogpost < ActiveRecord::Migration
  def change
  	add_column :blogposts, :tags, :text
  end
end
