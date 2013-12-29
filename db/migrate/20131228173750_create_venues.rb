class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :bookmark, default: false
      t.string :streetname
      t.integer :streetnumber
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :residentname
      t.text :notes
      t.references :user, index: true

      t.timestamps
    end
  end
end
