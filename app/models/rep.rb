class Rep < ActiveRecord::Base
  belongs_to :venue
  has_many :coms, dependent: :destroy
end
