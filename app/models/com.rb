class Com < ActiveRecord::Base
  belongs_to :rep
  belongs_to :sen
  belongs_to :del

end
