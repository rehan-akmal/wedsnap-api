class Conversation < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  belongs_to :gig, optional: true

  has_many :messages, dependent: :destroy

  validates :user1_id, presence: true
  validates :user2_id, presence: true
  validates :user1_id, uniqueness: { scope: :user2_id }

  scope :for_user, ->(user) { where('user1_id = ? OR user2_id = ?', user.id, user.id) }
  scope :ordered_by_recent, -> { order(last_message_at: :desc) }

  def other_user(current_user)
    current_user.id == user1_id ? user2 : user1
  end

  def unread_count_for(user)
    user.id == user1_id ? user1_unread_count : user2_unread_count
  end

  def mark_as_read_for_user(user)
    if user.id == user1_id
      update(user1_unread_count: 0)
    else
      update(user2_unread_count: 0)
    end
  end

  def increment_unread_for(user)
    if user.id == user1_id
      increment!(:user1_unread_count)
    else
      increment!(:user2_unread_count)
    end
  end

  def last_message
    messages.order(created_at: :desc).first
  end

  def self.between_users(user1_id, user2_id)
    where(
      '(user1_id = ? AND user2_id = ?) OR (user1_id = ? AND user2_id = ?)',
      user1_id, user2_id, user2_id, user1_id
    ).first
  end
end
