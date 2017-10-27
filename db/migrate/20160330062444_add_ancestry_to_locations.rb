class AddAncestryToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :ancestry, :string
    add_index :locations, :ancestry
  end
end
