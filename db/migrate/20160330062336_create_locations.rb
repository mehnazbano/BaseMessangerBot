class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :location_type

      t.timestamps null: false
    end
  end
end
