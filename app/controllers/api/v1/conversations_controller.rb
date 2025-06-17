module Api
  module V1
    class ConversationsController < ApplicationController
      before_action :set_conversation, only: [:show, :mark_as_read]

  # GET /api/v1/conversations
  def index
    conversations = @current_user.conversations
                               .includes(:user1, :user2, :gig, messages: :user)
                               .ordered_by_recent

    conversations_data = ConversationSerializer.serialize_collection(conversations, @current_user)
    render json: conversations_data
  end

  # GET /api/v1/conversations/:id
  def show
    conversation_data = ConversationSerializer.serialize(@conversation, @current_user)
    render json: conversation_data
  end

  # POST /api/v1/conversations
  def create
    other_user_id = params[:userId]
    gig_id = params[:gigId]

    # Validate that the other user exists
    other_user = User.find_by(id: other_user_id)
    unless other_user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    # Prevent users from creating conversations with themselves
    if @current_user.id == other_user_id.to_i
      render json: { error: 'Cannot create conversation with yourself' }, status: :unprocessable_entity
      return
    end

    # Check if conversation already exists
    existing_conversation = Conversation.between_users(@current_user.id, other_user_id)
    
    if existing_conversation
      render json: { 
        id: existing_conversation.id,
        message: 'Conversation already exists'
      }, status: :ok
      return
    end

    # Create new conversation
    @conversation = Conversation.new(
      user1_id: @current_user.id,
      user2_id: other_user_id,
      gig_id: gig_id,
      last_message_at: Time.current
    )

    if @conversation.save
      render json: { 
        id: @conversation.id,
        message: 'Conversation created successfully'
      }, status: :created
    else
      render json: { 
        errors: @conversation.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/conversations/:id/read
  def mark_as_read
    @conversation.mark_as_read_for_user(@current_user)
    render json: { message: 'Conversation marked as read' }, status: :ok
  end

  private

  def set_conversation
    @conversation = @current_user.conversations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
        render json: { error: 'Conversation not found' }, status: :not_found
      end
    end
  end
end
