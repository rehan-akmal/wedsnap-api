class User < ApplicationRecord
    has_one_attached :avatar
    has_many :gigs
    has_many :availabilities

    attr_accessor :password_confirmation

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }
    validates :role, presence: true, inclusion: { in: %w[user admin superadmin] }
    # validate :password_confirmation_match

    def avatar_url
        Rails.application.routes.url_helpers.
          rails_blob_url(avatar, only_path: true) if avatar.attached?
    end

    private

    def password_confirmation_match
        if password != password_confirmation
            errors.add(:password_confirmation, "doesn't match Password")
        end
    end
end

# app/models/user.rb
  
