class Feature < ApplicationRecord
  belongs_to :gig
  
  validates :name, presence: true
end
