class ExpertiseArea < ActiveRecord::Base
  has_many :expertises, :dependent => :destroy
  has_many :users, through: :expertises

end