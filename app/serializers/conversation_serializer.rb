class ConversationSerializer
  def self.serialize(conversation, current_user)
    other_user = conversation.other_user(current_user)
    last_message = conversation.last_message
    
    {
      id: conversation.id,
      user: {
        id: other_user.id,
        name: other_user.name,
        avatar: other_user.avatar_url,
        isOnline: false # TODO: Implement online status
      },
      lastMessage: last_message ? {
        text: last_message.content,
        timestamp: last_message.created_at,
        isRead: last_message.read || last_message.user_id == current_user.id,
        sender: last_message.user_id == current_user.id ? 'you' : 'them'
      } : nil,
      unreadCount: conversation.unread_count_for(current_user),
      gig: conversation.gig ? {
        id: conversation.gig.id,
        title: conversation.gig.title
      } : nil
    }
  end

  def self.serialize_collection(conversations, current_user)
    conversations.map { |conversation| serialize(conversation, current_user) }
  end
end 