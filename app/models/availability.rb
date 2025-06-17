class Availability < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :available, inclusion: { in: [true, false] }
  validates :date, uniqueness: { scope: :user_id, message: "availability already exists for this date" }

  # Scopes
  scope :available, -> { where(available: true) }
  scope :busy, -> { where(available: false) }
  scope :for_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :ordered_by_date, -> { order(:date) }

  # Ensure date is not in the past
  validate :date_not_in_past

  # Alias for easier access
  alias_attribute :is_available, :available

  private

  def date_not_in_past
    if date.present? && date < Date.current
      errors.add(:date, "cannot be in the past")
    end
  end
end
