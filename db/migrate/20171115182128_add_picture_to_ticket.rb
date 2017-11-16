class AddPictureToTicket < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.attachment :data
    end
  end
end
