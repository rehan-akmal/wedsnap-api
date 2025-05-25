class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.text :bio
      t.string :location
      t.string :phone
      t.string :role

      t.timestamps
    end
  end
end
