# db/seeds.rb

puts "Cleaning database..."
[Faq, Feature, Package, Gig, Availability, Category, User].each(&:destroy_all)

# Create users
puts "Creating users..."

superadmin = User.create!(
  name: 'Super Admin',
  email: 'superadmin@admin.com',
  password: 'admin123',
  role: 'superadmin'
)

seller1 = User.create!(
  name: 'Ali Khan',
  email: 'ali@example.com',
  password: 'password1',
  bio: 'Experienced graphic designer.',
  location: 'Karachi',
  phone: '03001234567',
  role: 'user'
)

seller2 = User.create!(
  name: 'Maryam Shah',
  email: 'maryam@example.com',
  password: 'password2',
  bio: 'Professional writer and editor.',
  location: 'Lahore',
  phone: '03007654321',
  role: 'user'
)

buyer = User.create!(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password3',
  role: 'user'
)

# Create categories
puts "Creating categories..."
category_names = %w[Design Writing Programming Music]
categories = category_names.map { |name| Category.create!(name: name) }

# Create availabilities for sellers
puts "Creating availabilities..."
[
  { user: seller1, day_of_week: 1, start_time: '09:00', end_time: '17:00' },
  { user: seller1, day_of_week: 3, start_time: '10:00', end_time: '18:00' },
  { user: seller2, day_of_week: 2, start_time: '11:00', end_time: '15:00' },
  { user: seller2, day_of_week: 4, start_time: '12:00', end_time: '16:00' }
].each { |attrs| Availability.create!(attrs) }

# Create gigs with nested resources
puts "Creating gigs and nested resources..."

gig1 = seller1.gigs.create!(
  title: 'Professional Logo Design',
  description: 'I will create a unique professional logo for your brand.',
  location: 'Karachi'
)
gig1.packages.create!([
  { name: 'Basic', description: 'Simple black & white logo', price: 50.0, delivery_days: 3, revisions: 1 },
  { name: 'Standard', description: 'Color logo with 2 concepts', price: 100.0, delivery_days: 5, revisions: 3 },
  { name: 'Premium', description: 'Full branding kit', price: 200.0, delivery_days: 7, revisions: 5 }
])
gig1.features.create!([
  { name: 'Source files included' },
  { name: 'Printing-ready formats' }
])
gig1.faqs.create!([
  { question: 'Do you deliver source files?', answer: 'Yes, all source files are included.' }
])

gig2 = seller1.gigs.create!(
  title: 'Social Media Graphics',
  description: 'I will design engaging social media images.',
  location: 'Karachi'
  
)
gig2.packages.create!([
  { name: 'Basic', description: '1 static image', price: 20.0, delivery_days: 2, revisions: 1 },
  { name: 'Standard', description: '3 images', price: 50.0, delivery_days: 4, revisions: 2 }
])
gig2.features.create!([
  { name: 'High-resolution' },
  { name: 'Stock photos included' }
])
gig2.faqs.create!([
  { question: 'Can you format to different sizes?', answer: 'Yes, up to 5 different sizes.' }
])

gig3 = seller2.gigs.create!(
  title: 'SEO Article Writing',
  description: 'I will write SEO-optimized articles for your blog.',
  location: 'Lahore',
)
gig3.packages.create!([
  { name: 'Basic', description: '500-word article', price: 30.0, delivery_days: 3, revisions: 1 },
  { name: 'Standard', description: '1000-word article', price: 60.0, delivery_days: 5, revisions: 2 },
  { name: 'Premium', description: '2000-word article with SEO keyword research', price: 120.0, delivery_days: 7, revisions: 3 }
])
gig3.features.create!([
  { name: 'SEO-friendly headers' },
  { name: 'Plagiarism-free content' }
])
gig3.faqs.create!([
  { question: 'Do you provide sources?', answer: 'Yes, all facts are backed by reliable sources.' }
])

gig4 = seller2.gigs.create!(
  title: 'Proofreading and Editing',
  description: 'I will proofread and edit your documents.',
  location: 'Lahore',
  
)
gig4.packages.create!([
  { name: 'Basic', description: 'Proofread up to 500 words', price: 15.0, delivery_days: 1, revisions: 1 },
  { name: 'Standard', description: 'Proofread up to 1500 words with minor edits', price: 45.0, delivery_days: 3, revisions: 2 }
])
gig4.features.create!([
  { name: 'Grammar and spelling check' },
  { name: 'Clarity improvements' }
])
gig4.faqs.create!([
  { question: 'What format do you accept?', answer: 'Word, PDF, or plain text.' }
])

gig5 = seller1.gigs.create!(
  title: 'Web App Development',
  description: 'I will develop your web application with Rails.',
  location: 'Remote',
)
gig5.packages.create!([
  { name: 'Basic', description: 'Simple CRUD app', price: 500.0, delivery_days: 7, revisions: 1 }
])
gig5.features.create!([
  { name: 'RESTful API' }
])
gig5.faqs.create!([
  { question: 'Do you provide deployment?', answer: 'Yes, deployment to Heroku or AWS.' }
])

puts "Seeding completed!"
