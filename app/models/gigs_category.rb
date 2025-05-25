class GigsCategory < ApplicationRecord
  belongs_to :gig
  belongs_to :category
end
