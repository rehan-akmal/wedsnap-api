
class ChatMailer < ApplicationMailer
  def new_message_notification(message, recipient)
    @message = message
    @sender = message.user
    @recipient = recipient
    @conversation = message.conversation
    
    mail(
      to: recipient.email,
      subject: "New message from #{@sender.name} - WedSnap"
    )
  end
end 