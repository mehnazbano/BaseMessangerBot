class CreateMicroblogs < ActiveRecord::Migration
  def change
    create_table :microblogs do |t|
      t.string :title
      t.string :description
      t.integer :user_id
      t.string :tags

      t.timestamps null: false
    end
  end
end
