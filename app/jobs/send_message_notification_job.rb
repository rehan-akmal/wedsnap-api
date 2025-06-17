class SendMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    conversation = message.conversation
    recipient = conversation.other_user(message.user)

    # Check if recipient has email notifications enabled
    # For now, we'll send to all users, but you can add notification preferences later
    return unless recipient.email.present?

    # Send email notification
    ChatMailer.new_message_notification(message, recipient).deliver_now
  rescue ActiveRecord::RecordNotFound
    # Message was deleted, skip sending email
    Rails.logger.warn "Message #{message_id} not found, skipping email notification"
  rescue => e
    Rails.logger.error "Failed to send message notification for message #{message_id}: #{e.message}"
    # Re-raise the error to trigger retry mechanism
    raise e
  end
end 