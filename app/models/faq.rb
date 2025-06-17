class Faq < ApplicationRecord
  belongs_to :gig
  
  validates :question, presence: true
  validates :answer, presence: true
end
