class AddColumnOptionFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :option, :string

  end
end
