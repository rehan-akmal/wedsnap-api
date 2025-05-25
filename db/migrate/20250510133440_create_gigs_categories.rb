class CreateGigsCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :gigs_categories do |t|
      t.references :gig, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
