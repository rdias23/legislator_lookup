class AddResidentFirstToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :resident_first, :string
  end
end
