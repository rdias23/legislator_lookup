class Venue < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode

  belongs_to :user
  has_many :reps, dependent: :destroy
  has_many :sens, dependent: :destroy



end
