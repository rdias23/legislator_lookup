class AddVenueRefToZooms < ActiveRecord::Migration
  def change
    add_reference :zooms, :venue, index: true
  end
end
