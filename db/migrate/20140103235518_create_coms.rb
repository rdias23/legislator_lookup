class CreateComs < ActiveRecord::Migration
  def change
    create_table :coms do |t|
      t.string :chamber
      t.string :committee_id
      t.string :name
      t.string :parent_committee_id
      t.boolean :subcommittee
      t.references :rep, index: true
      t.references :sen, index: true

      t.timestamps
    end
  end
end
