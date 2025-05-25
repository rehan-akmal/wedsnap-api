class CreateFaqs < ActiveRecord::Migration[7.1]
  def change
    create_table :faqs do |t|
      t.references :gig, null: false, foreign_key: true
      t.string :question
      t.text :answer

      t.timestamps
    end
  end
end
