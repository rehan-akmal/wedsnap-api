# Email Setup Guide for WedSnap

This guide explains how to set up email notifications for chat messages using LetterOpener for development.

## Features

- **Email Notifications**: Every chat message triggers an email notification to the recipient
- **LetterOpener Integration**: In development, emails are opened in your browser instead of being sent
- **Background Processing**: Email sending is handled by Sidekiq to avoid blocking the main application
- **Beautiful Templates**: HTML and text email templates with responsive design

## Setup Instructions

### 1. Install Dependencies

```bash
# Install the new gems
bundle install
```

### 2. Start Redis (Required for Sidekiq)

```bash
# On macOS with Homebrew
brew install redis
brew services start redis

# On Ubuntu/Debian
sudo apt-get install redis-server
sudo systemctl start redis

# Or using Docker
docker run -d -p 6379:6379 redis:alpine
```

### 3. Start the Application

#### Option A: Using Foreman (Recommended)
```bash
# Install foreman if you don't have it
gem install foreman

# Start both Rails server and Sidekiq
foreman start -f Procfile.dev
```

#### Option B: Manual Start
```bash
# Terminal 1: Start Rails server
bundle exec rails server -p 3001

# Terminal 2: Start Sidekiq
bundle exec sidekiq -C config/sidekiq.yml
```

### 4. Test Email Functionality

1. Start a conversation between two users
2. Send a message from one user to another
3. Check your browser - LetterOpener will automatically open the email in a new tab
4. The email will show the message content, sender information, and a link to view the message

## How It Works

### Email Flow
1. User sends a message via the API
2. Message is saved to the database
3. `after_create` callback triggers `SendMessageNotificationJob`
4. Background job finds the recipient and sends email via `ChatMailer`
5. In development, LetterOpener opens the email in your browser

### Files Added/Modified

#### New Files:
- `app/mailers/chat_mailer.rb` - Email mailer for chat notifications
- `app/views/chat_mailer/new_message_notification.html.erb` - HTML email template
- `app/views/chat_mailer/new_message_notification.text.erb` - Text email template
- `app/jobs/send_message_notification_job.rb` - Background job for sending emails
- `config/sidekiq.yml` - Sidekiq configuration
- `config/initializers/sidekiq.rb` - Sidekiq Redis configuration
- `Procfile.dev` - Development process configuration

#### Modified Files:
- `Gemfile` - Added Sidekiq, Redis, and LetterOpener gems
- `config/environments/development.rb` - Configured LetterOpener and Sidekiq
- `app/models/message.rb` - Added email notification callback
- `app/mailers/application_mailer.rb` - Updated default from address

## Configuration

### Environment Variables

You can set these environment variables to customize the setup:

```bash
# Frontend URL for email links
FRONTEND_URL=http://localhost:3000

# Redis URL (defaults to localhost:6379)
REDIS_URL=redis://localhost:6379/0
```

### Email Templates

The email templates are located in:
- `app/views/chat_mailer/new_message_notification.html.erb` - HTML version
- `app/views/chat_mailer/new_message_notification.text.erb` - Text version

You can customize the design, content, and branding in these files.

## Production Setup

For production, you'll need to:

1. Configure a real email service (SendGrid, Mailgun, etc.)
2. Update `config/environments/production.rb` with SMTP settings
3. Set up Redis in production
4. Configure Sidekiq to run as a service

Example production email configuration:

```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'yourdomain.com',
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Troubleshooting

### LetterOpener not opening emails
- Make sure you're in development environment
- Check that `config.action_mailer.delivery_method = :letter_opener` is set
- Ensure `config.action_mailer.perform_deliveries = true` is set

### Sidekiq not processing jobs
- Check that Redis is running: `redis-cli ping`
- Verify Sidekiq is running: `bundle exec sidekiq -C config/sidekiq.yml`
- Check Sidekiq web interface at `http://localhost:3001/sidekiq` (if configured)

### Emails not being sent
- Check Rails logs for errors
- Verify the recipient has a valid email address
- Check that the background job is being enqueued

## Monitoring

You can monitor background jobs by adding the Sidekiq web interface:

```ruby
# config/routes.rb
require 'sidekiq/web'

Rails.application.routes.draw do
  # ... existing routes ...
  
  # Sidekiq web interface (protect in production)
  mount Sidekiq::Web => '/sidekiq'
end
```

Then visit `http://localhost:3001/sidekiq` to monitor job processing. 