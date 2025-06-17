class UpdateAvailabilitiesForCalendar < ActiveRecord::Migration[7.1]
  def change
    # Remove old columns
    remove_column :availabilities, :day_of_week, :integer
    remove_column :availabilities, :start_time, :time
    remove_column :availabilities, :end_time, :time
    
    # Add new columns for date-based availability
    add_column :availabilities, :date, :date, null: false
    add_column :availabilities, :available, :boolean, default: true, null: false
    
    # Add index for better performance
    add_index :availabilities, [:user_id, :date], unique: true
  end
end
