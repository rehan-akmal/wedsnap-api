class AddPhoneNumberToGigs < ActiveRecord::Migration[7.1]
  def change
    add_column :gigs, :phone_number, :string
  end
end
