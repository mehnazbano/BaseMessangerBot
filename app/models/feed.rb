class Feed < ActiveRecord::Base
  validates :description, presence: true, :uniqueness => true, length: { minimum: 10, maximum: 100 }
  has_attached_file :data,
    url:  "/assets/attachement/data/:id/:style/:basename.:extension",
    path: ":rails_root/public/assets/attachement/data/:id/:style/:basename.:extension"
  #do_not_validate_attachment_file_type :data
  validates_attachment_content_type :data, content_type: ["image/jpeg", "image/png", "image/jpg","application/pdf","application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain"]
end
