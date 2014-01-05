class AddResidentLastToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :resident_last, :string
  end
end
