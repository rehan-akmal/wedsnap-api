class Gig < ApplicationRecord
  belongs_to :user
  has_many :packages, dependent: :destroy
  has_many :features, dependent: :destroy
  has_many :faqs, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :categories, through: :category_gigs
  
end
