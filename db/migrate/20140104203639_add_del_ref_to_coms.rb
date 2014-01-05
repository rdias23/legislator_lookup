class AddDelRefToComs < ActiveRecord::Migration
  def change
    add_reference :coms, :del, index: true
  end
end
