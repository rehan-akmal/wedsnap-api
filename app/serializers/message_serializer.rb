class MessageSerializer
  def self.serialize(message, current_user)
    {
      id: message.id,
      text: message.content,
      timestamp: message.created_at,
      sender: message.user_id == current_user.id ? 'you' : 'them',
      read: message.read,
      user: {
        id: message.user.id,
        name: message.user.name,
        avatar: message.user.avatar_url
      }
    }
  end

  def self.serialize_collection(messages, current_user)
    messages.map { |message| serialize(message, current_user) }
  end
end 