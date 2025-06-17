class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :user1, null: false, foreign_key: { to_table: :users }
      t.references :user2, null: false, foreign_key: { to_table: :users }
      t.references :gig, null: true, foreign_key: true
      t.datetime :last_message_at
      t.integer :user1_unread_count, default: 0
      t.integer :user2_unread_count, default: 0

      t.timestamps
    end

    add_index :conversations, [:user1_id, :user2_id], unique: true
    add_index :conversations, [:user2_id, :user1_id], unique: true
  end
end
