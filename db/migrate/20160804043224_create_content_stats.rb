class CreateContentStats < ActiveRecord::Migration
  def change
    create_table :content_stats do |t|
      t.integer :content_id
      t.string :content_type
      t.integer :likes_count
      t.string :user_id
      t.string :integer

      t.timestamps null: false
    end
  end
end
