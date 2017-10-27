class CreateExpertises < ActiveRecord::Migration
  def change
    create_table :expertises do |t|
      t.integer :user_id
      t.integer :expertise_area_id
      t.integer :subexpertise_id

      t.timestamps null: false
    end
  end
end
