class Expertise < ActiveRecord::Base
  belongs_to :user
  belongs_to :expertise_area
end