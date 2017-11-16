class RenameUserIdTicktes < ActiveRecord::Migration
  def change
    change_column :tickets, :fb_app_user_id, :text
  end
end
