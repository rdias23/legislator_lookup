class CreateZooms < ActiveRecord::Migration
  def change
    create_table :zooms do |t|
      t.integer :level, default: 6
      t.references :user, index: true

      t.timestamps
    end
  end
end
