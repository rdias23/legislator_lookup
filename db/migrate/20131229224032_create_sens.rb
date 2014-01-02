class CreateSens < ActiveRecord::Migration
  def change
    create_table :sens do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :name_suffix
      t.string :gender
      t.string :title
      t.string :bioguide_id
      t.string :birthday
      t.string :chamber
      t.string :contact_form
      t.integer :district
      t.string :facebook_id
      t.string :fax
      t.boolean :in_office
      t.string :nickname
      t.string :office
      t.string :party
      t.string :phone
      t.string :state
      t.string :state_name
      t.string :term_end
      t.string :term_start
      t.string :twitter_id
      t.string :website
      t.string :youtube_id
      t.string :state_rank
      t.string :senate_class
      t.references :venue, index: true

      t.timestamps
    end
  end
end
