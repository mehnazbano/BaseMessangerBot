class AddAttachmentDataToFeeds < ActiveRecord::Migration
  def self.up
    change_table :feeds do |t|
      t.attachment :data
    end
  end

  def self.down
    remove_attachment :feeds, :data
  end
end
