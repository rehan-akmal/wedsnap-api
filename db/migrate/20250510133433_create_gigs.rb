class CreateGigs < ActiveRecord::Migration[7.1]
  def change
    create_table :gigs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
