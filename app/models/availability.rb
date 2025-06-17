class Availability < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :is_available, inclusion: { in: [true, false] }
  validates :date, uniqueness: { scope: :user_id, message: "availability already exists for this date" }

  # Scopes
  scope :available, -> { where(is_available: true) }
  scope :busy, -> { where(is_available: false) }
  scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :ordered_by_date, -> { order(:date) }

  # Ensure date is not in the past
  validate :date_not_in_past

  # Alias for easier access
  alias_attribute :available, :is_available

  private

  def date_not_in_past
    if date.present? && date < Date.current
      errors.add(:date, "cannot be in the past")
    end
  end
end
