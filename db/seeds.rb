# db/seeds.rb

puts "Cleaning database..."
[Message, Conversation, Faq, Feature, Package, Gig, Availability, Category, User].each(&:destroy_all)

# Create super admin with username and password 'admin'
puts "Creating super admin..."
superadmin = User.create!(
  name: 'Super Admin',
  email: 'admin@admin.com',
  password: 'admin123',
  role: 'superadmin',
  bio: 'System Super Administrator',
  location: 'System',
  phone: '+1234567890'
)

puts "Super admin created with email: admin@admin.com and password: admin123"

# Create additional admin users
admin1 = User.create!(
  name: 'Admin User',
  email: 'admin@wedsnap.com',
  password: 'admin123',
  role: 'admin',
  bio: 'System Administrator',
  location: 'Karachi',
  phone: '+923001234567'
)

# Create regular users
puts "Creating users..."

seller1 = User.create!(
  name: 'Ali Khan',
  email: 'ali@example.com',
  password: 'password1',
  bio: 'Experienced graphic designer with 5+ years in wedding photography and design.',
  location: 'Karachi',
  phone: '03001234567',
  role: 'user'
)

seller2 = User.create!(
  name: 'Maryam Shah',
  email: 'maryam@example.com',
  password: 'password2',
  bio: 'Professional writer and editor specializing in wedding content.',
  location: 'Lahore',
  phone: '03007654321',
  role: 'user'
)

seller3 = User.create!(
  name: 'Ahmed Hassan',
  email: 'ahmed@example.com',
  password: 'password3',
  bio: 'Wedding videographer with expertise in cinematic wedding films.',
  location: 'Islamabad',
  phone: '03009876543',
  role: 'user'
)

seller4 = User.create!(
  name: 'Fatima Ali',
  email: 'fatima@example.com',
  password: 'password4',
  bio: 'Professional makeup artist specializing in bridal makeup.',
  location: 'Rawalpindi',
  phone: '03005556666',
  role: 'user'
)

seller5 = User.create!(
  name: 'Usman Khan',
  email: 'usman@example.com',
  password: 'password5',
  bio: 'Wedding planner with 10+ years of experience in luxury weddings.',
  location: 'Faisalabad',
  phone: '03004445555',
  role: 'user'
)

buyer1 = User.create!(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password6',
  bio: 'Looking for wedding services',
  location: 'New York',
  phone: '+1234567890',
  role: 'user'
)

buyer2 = User.create!(
  name: 'Sarah Smith',
  email: 'sarah@example.com',
  password: 'password7',
  bio: 'Planning my dream wedding',
  location: 'London',
  phone: '+44123456789',
  role: 'user'
)

# Create test users for chat functionality
user1 = User.find_or_create_by(email: 'alice@example.com') do |user|
  user.name = 'Alice Johnson'
  user.password = 'password123'
  user.role = 'user'
  user.bio = 'Wedding photographer'
  user.location = 'Toronto'
  user.phone = '+14165551234'
end

user2 = User.find_or_create_by(email: 'bob@example.com') do |user|
  user.name = 'Bob Smith'  
  user.password = 'password123'
  user.role = 'user'
  user.bio = 'Event planner'
  user.location = 'Vancouver'
  user.phone = '+16045551234'
end

user3 = User.find_or_create_by(email: 'charlie@example.com') do |user|
  user.name = 'Charlie Brown'
  user.password = 'password123'
  user.role = 'user'
  user.bio = 'Wedding DJ'
  user.location = 'Montreal'
  user.phone = '+15145551234'
end

puts "Created test users: #{[user1.name, user2.name, user3.name].join(', ')}"

# Create categories
puts "Creating categories..."
category_names = [
  'Wedding Photography',
  'Wedding Videography', 
  'Wedding Planning',
  'Bridal Makeup',
  'Wedding Decor',
  'Wedding Music',
  'Wedding Catering',
  'Wedding Transportation',
  'Wedding Attire',
  'Wedding Jewelry'
]
categories = category_names.map { |name| Category.create!(name: name) }

# Create some sample availabilities for testing
puts "Creating sample availabilities..."

# Create availabilities for seller1
seller1.availabilities.create!([
  { date: Date.current + 1.day, available: true },
  { date: Date.current + 2.days, available: true },
  { date: Date.current + 3.days, available: false },
  { date: Date.current + 4.days, available: true },
  { date: Date.current + 5.days, available: false },
  { date: Date.current + 6.days, available: true },
  { date: Date.current + 7.days, available: true },
  { date: Date.current + 8.days, available: true },
  { date: Date.current + 9.days, available: false },
  { date: Date.current + 10.days, available: true },
])

# Create availabilities for seller2
seller2.availabilities.create!([
  { date: Date.current + 1.day, available: false },
  { date: Date.current + 2.days, available: true },
  { date: Date.current + 3.days, available: true },
  { date: Date.current + 4.days, available: false },
  { date: Date.current + 5.days, available: true },
  { date: Date.current + 6.days, available: true },
  { date: Date.current + 7.days, available: false },
  { date: Date.current + 8.days, available: true },
  { date: Date.current + 9.days, available: true },
  { date: Date.current + 10.days, available: false },
])

# Create availabilities for seller3
seller3.availabilities.create!([
  { date: Date.current + 1.day, available: true },
  { date: Date.current + 2.days, available: false },
  { date: Date.current + 3.days, available: true },
  { date: Date.current + 4.days, available: true },
  { date: Date.current + 5.days, available: true },
  { date: Date.current + 6.days, available: false },
  { date: Date.current + 7.days, available: true },
  { date: Date.current + 8.days, available: false },
  { date: Date.current + 9.days, available: true },
  { date: Date.current + 10.days, available: true },
])

puts "Sample availabilities created!"

# Create gigs with nested resources
puts "Creating gigs and nested resources..."

# Wedding Photography Gigs
gig1 = seller1.gigs.create!(
  title: 'Professional Wedding Photography Package',
  description: 'Capture your special day with beautiful, timeless photos. Professional wedding photography with 8+ hours coverage, edited photos, and online gallery.',
  location: 'Karachi',
  phone_number: '03001234567'
)
gig1.categories << categories[0] # Wedding Photography
gig1.packages.create!([
  { name: 'Basic Package', description: '4 hours coverage, 200 edited photos, online gallery', price: 50000.0, delivery_days: 14, revisions: 2 },
  { name: 'Standard Package', description: '8 hours coverage, 400 edited photos, online gallery, engagement shoot', price: 80000.0, delivery_days: 21, revisions: 3 },
  { name: 'Premium Package', description: 'Full day coverage, 600 edited photos, online gallery, engagement shoot, wedding album', price: 120000.0, delivery_days: 30, revisions: 5 }
])
gig1.features.create!([
  { name: 'High-resolution photos' },
  { name: 'Online gallery' },
  { name: 'Print-ready files' },
  { name: 'Engagement shoot included' }
])
gig1.faqs.create!([
  { question: 'How many photos will I receive?', answer: 'You will receive 200-600 edited photos depending on your package.' },
  { question: 'Do you provide raw files?', answer: 'Yes, raw files are included in all packages.' },
  { question: 'How long does editing take?', answer: 'Editing takes 14-30 days depending on your package.' }
])

gig2 = seller1.gigs.create!(
  title: 'Wedding Videography & Photography Combo',
  description: 'Complete wedding coverage with both photography and videography. Professional equipment and editing.',
  location: 'Karachi',
  phone_number: '03001234567'
)
gig2.categories << categories[0] # Wedding Photography
gig2.categories << categories[1] # Wedding Videography
gig2.packages.create!([
  { name: 'Combo Basic', description: '6 hours coverage, 300 photos, 3-5 min highlight video', price: 75000.0, delivery_days: 21, revisions: 2 },
  { name: 'Combo Premium', description: 'Full day coverage, 500 photos, 5-8 min highlight video, full ceremony video', price: 120000.0, delivery_days: 30, revisions: 3 }
])
gig2.features.create!([
  { name: '4K video quality' },
  { name: 'Drone footage' },
  { name: 'Highlight video' },
  { name: 'Full ceremony video' }
])

# Wedding Planning Gigs
gig3 = seller2.gigs.create!(
  title: 'Complete Wedding Planning & Coordination',
  description: 'Professional wedding planning services from concept to execution. Stress-free wedding planning experience.',
  location: 'Lahore',
  phone_number: '03007654321'
)
gig3.categories << categories[2] # Wedding Planning
gig3.packages.create!([
  { name: 'Day-of Coordination', description: 'Wedding day coordination and vendor management', price: 25000.0, delivery_days: 1, revisions: 1 },
  { name: 'Partial Planning', description: '3 months planning support, vendor recommendations, day coordination', price: 50000.0, delivery_days: 90, revisions: 3 },
  { name: 'Full Planning', description: 'Complete wedding planning from start to finish', price: 100000.0, delivery_days: 180, revisions: 5 }
])
gig3.features.create!([
  { name: 'Vendor recommendations' },
  { name: 'Budget management' },
  { name: 'Timeline creation' },
  { name: 'Day-of coordination' }
])
gig3.faqs.create!([
  { question: 'Do you work with specific vendors?', answer: 'I have a network of trusted vendors but can work with your preferred vendors too.' },
  { question: 'What areas do you serve?', answer: 'I serve Lahore and surrounding areas within 50km.' }
])

# Bridal Makeup Gigs
gig4 = seller4.gigs.create!(
  title: 'Professional Bridal Makeup & Hair Styling',
  description: 'Professional bridal makeup and hair styling for your special day. Using premium products and latest techniques.',
  location: 'Rawalpindi',
  phone_number: '03005556666'
)
gig4.categories << categories[3] # Bridal Makeup
gig4.packages.create!([
  { name: 'Bridal Makeup Only', description: 'Professional bridal makeup with premium products', price: 15000.0, delivery_days: 1, revisions: 1 },
  { name: 'Bridal Makeup & Hair', description: 'Complete bridal look with makeup and hair styling', price: 25000.0, delivery_days: 1, revisions: 1 },
  { name: 'Complete Bridal Package', description: 'Bridal makeup, hair, and bridesmaid makeup for 2 people', price: 35000.0, delivery_days: 1, revisions: 1 }
])
gig4.features.create!([
  { name: 'Premium makeup products' },
  { name: 'Hair styling included' },
  { name: 'Touch-up kit provided' },
  { name: 'Trial session included' }
])

# Wedding Decor Gigs
gig5 = seller5.gigs.create!(
  title: 'Luxury Wedding Decoration & Setup',
  description: 'Beautiful wedding decorations and setup services. From intimate gatherings to grand celebrations.',
  location: 'Faisalabad',
  phone_number: '03004445555'
)
gig5.categories << categories[4] # Wedding Decor
gig5.packages.create!([
  { name: 'Basic Decoration', description: 'Basic wedding decoration with flowers and lighting', price: 30000.0, delivery_days: 1, revisions: 2 },
  { name: 'Premium Decoration', description: 'Luxury decoration with premium flowers, lighting, and props', price: 60000.0, delivery_days: 1, revisions: 3 },
  { name: 'Complete Setup', description: 'Full wedding setup including stage, seating, and decoration', price: 100000.0, delivery_days: 2, revisions: 3 }
])
gig5.features.create!([
  { name: 'Fresh flowers' },
  { name: 'Professional lighting' },
  { name: 'Setup and cleanup' },
  { name: 'Custom themes available' }
])

# Wedding Music Gigs
gig6 = user1.gigs.create!(
  title: 'Wedding DJ & Live Music Services',
  description: 'Professional DJ and live music services for your wedding. Creating the perfect atmosphere for your special day.',
  location: 'Toronto',
  phone_number: '+14165551234'
)
gig6.categories << categories[5] # Wedding Music
gig6.packages.create!([
  { name: 'DJ Package', description: 'Professional DJ with sound system for 4 hours', price: 800.0, delivery_days: 1, revisions: 1 },
  { name: 'Live Music Package', description: 'Live band performance for 3 hours', price: 1500.0, delivery_days: 1, revisions: 1 },
  { name: 'Complete Music Package', description: 'DJ + live music combination for 6 hours', price: 2000.0, delivery_days: 1, revisions: 1 }
])
gig6.features.create!([
  { name: 'Professional sound system' },
  { name: 'Custom playlist creation' },
  { name: 'MC services included' },
  { name: 'Setup and teardown' }
])

# Create conversations for testing
puts "Creating sample conversations..."

conversation1 = Conversation.create!(
  user1: buyer1,
  user2: seller1,
  gig: gig1,
  last_message_at: Time.current
)

conversation2 = Conversation.create!(
  user1: buyer2,
  user2: seller2,
  gig: gig3,
  last_message_at: Time.current
)

conversation3 = Conversation.create!(
  user1: user1,
  user2: user2,
  gig: gig6,
  last_message_at: Time.current
)

# Create messages for conversations
Message.create!([
  { conversation: conversation1, user: buyer1, content: "Hi, I'm interested in your wedding photography package. Do you have availability for December 15th?" },
  { conversation: conversation1, user: seller1, content: "Hello! Yes, I'm available on December 15th. Which package are you interested in?" },
  { conversation: conversation1, user: buyer1, content: "I'm thinking about the Standard Package. What's included in the engagement shoot?" },
  
  { conversation: conversation2, user: buyer2, content: "Hi, I need help planning my wedding. Do you offer full planning services?" },
  { conversation: conversation2, user: seller2, content: "Yes, I offer complete wedding planning services. When is your wedding date?" },
  
  { conversation: conversation3, user: user1, content: "Looking for DJ services for my wedding next month." },
  { conversation: conversation3, user: user2, content: "I can help you with that! What's your budget and preferred music style?" }
])

puts "Sample conversations and messages created!"

puts "Seeding completed!"
puts "Super Admin Login:"
puts "Email: admin@admin.com"
puts "Password: admin123"
puts ""
puts "Total users created: #{User.count}"
puts "Total gigs created: #{Gig.count}"
puts "Total categories created: #{Category.count}"
puts "Total conversations created: #{Conversation.count}"
puts "Total messages created: #{Message.count}"
