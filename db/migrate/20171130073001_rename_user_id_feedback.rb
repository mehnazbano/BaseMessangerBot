class RenameUserIdFeedback < ActiveRecord::Migration
  def change
    change_column :feedbacks, :fb_app_user_id, :text
  end
end
