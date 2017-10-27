class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :expertises, :dependent => :destroy
  has_many :expertise_areas, through: :expertises
  has_many :feeds
  # validates_email_realness_of :email

  #searchable do
  	#string :email
  #end
end
