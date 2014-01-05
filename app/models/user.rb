class User < ActiveRecord::Base
  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :venues, dependent: :destroy
  has_many :reps, :through => :venues
  has_many :sens, :through => :venues
  has_many :dels, :through => :venues
  has_many :zooms, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
