class CreateFeatures < ActiveRecord::Migration[7.1]
  def change
    create_table :features do |t|
      t.references :gig, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
