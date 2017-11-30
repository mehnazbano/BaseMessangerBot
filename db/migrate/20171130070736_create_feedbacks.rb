class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :fb_app_user_id
      t.text :description
      t.attachment :data
      t.timestamps null: false
    end
  end
end
