namespace :db do
  desc "Set plain text passwords for existing users"
  task set_plain_passwords: :environment do
    puts "Setting plain text passwords for existing users..."
    
    User.find_each do |user|
      # Set a default password for existing users
      default_password = "password123"
      user.password = default_password
      
      if user.save
        puts "Set password for user: #{user.email}"
      else
        puts "Failed to set password for user: #{user.email} - #{user.errors.full_messages}"
      end
    end
    
    puts "Password setup completed!"
    puts "Default password for all users is now: password123"
  end
end 