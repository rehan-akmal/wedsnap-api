class Category < ApplicationRecord
  has_many :gigs_categories, dependent: :destroy
  has_many :gigs, through: :gigs_categories
  
  validates :name, presence: true, uniqueness: true
end
