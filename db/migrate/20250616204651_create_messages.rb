class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.boolean :read, default: false
      t.string :message_type, default: 'text'

      t.timestamps
    end

    add_index :messages, :created_at
  end
end
