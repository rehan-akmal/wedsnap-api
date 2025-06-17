class User < ApplicationRecord
    has_one_attached :avatar
    has_many :gigs, dependent: :destroy
    has_many :conversations, dependent: :destroy
    has_many :messages, dependent: :destroy
    has_many :availabilities, dependent: :destroy
    
    # Conversation associations
    has_many :initiated_conversations, class_name: 'Conversation', foreign_key: 'user1_id', dependent: :destroy
    has_many :received_conversations, class_name: 'Conversation', foreign_key: 'user2_id', dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true, inclusion: { in: %w[user admin superadmin] }
    validates :phone, format: { with: /\A\+?[\d\s-]+\z/, message: "must be a valid phone number", allow_blank: true }

    def avatar_url
        return nil unless avatar.attached?
        Rails.application.routes.url_helpers.
          rails_blob_url(avatar, only_path: true)
    end

    def conversations
        Conversation.for_user(self)
    end

    # Settings methods
    def settings
        self[:settings] || {}
    end

    def settings=(value)
        self[:settings] = value
    end

    def notification_settings
        settings['notifications'] || {
            email: true,
            messages: true,
            orders: true,
            marketing: false
        }
    end

    def availability_settings
        settings['availability'] || {
            days: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
            startTime: '09:00',
            endTime: '17:00'
        }
    end
end