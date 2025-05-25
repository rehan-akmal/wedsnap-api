class CreatePackages < ActiveRecord::Migration[7.1]
  def change
    create_table :packages do |t|
      t.references :gig, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :delivery_days
      t.integer :revisions

      t.timestamps
    end
  end
end
