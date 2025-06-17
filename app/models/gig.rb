class Gig < ApplicationRecord
  belongs_to :user
  has_many :packages, dependent: :destroy
  has_many :features, dependent: :destroy
  has_many :faqs, dependent: :destroy
  has_many :conversations, dependent: :destroy
  # has_many :orders, dependent: :destroy  # TODO: Create Order model
  has_many_attached :images
  has_many :gigs_categories, dependent: :destroy
  has_many :categories, through: :gigs_categories
  
  # Validations
  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :description, presence: true, length: { minimum: 50, maximum: 2000 }
  validates :location, presence: true
  validates :phone_number, presence: true, format: { with: /\A\+?[\d\s-]+\z/, message: "must be a valid phone number" }
  
  # Nested attributes
  accepts_nested_attributes_for :packages, allow_destroy: true
  accepts_nested_attributes_for :features, allow_destroy: true
  accepts_nested_attributes_for :faqs, allow_destroy: true
end
