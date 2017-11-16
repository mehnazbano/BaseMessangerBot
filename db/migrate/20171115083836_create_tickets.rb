class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :fb_app_user_id
      t.string :category
      t.text :description
      t.integer :status
      t.string :severity

      t.timestamps null: false
    end
  end
end
