class Package < ApplicationRecord
  belongs_to :gig
  
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :delivery_days, presence: true, numericality: { greater_than: 0 }
  validates :revisions, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
