class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :content, presence: true, length: { minimum: 1, maximum: 1000 }
  validates :message_type, inclusion: { in: ['text'] }

  after_create :update_conversation_timestamp
  after_create :increment_unread_count
  after_create :send_email_notification

  scope :ordered_by_time, -> { order(created_at: :asc) }
  scope :unread, -> { where(read: false) }

  private

  def update_conversation_timestamp
    conversation.update(last_message_at: created_at)
  end

  def increment_unread_count
    # Increment unread count for the other user in the conversation
    other_user = conversation.other_user(user)
    conversation.increment_unread_for(other_user)
  end

  def send_email_notification
    # Send email notification in background
    SendMessageNotificationJob.perform_later(id)
  end
end
