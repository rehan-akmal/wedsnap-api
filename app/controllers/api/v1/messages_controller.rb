module Api
  module V1
    class MessagesController < ApplicationController
      before_action :set_conversation

    # GET /api/v1/conversations/:conversation_id/messages
      def index
        messages = @conversation.messages
                              .includes(:user)
                              .ordered_by_time
                              .page(params[:page])
                              .per(params[:per_page] || 50)

        messages_data = MessageSerializer.serialize_collection(messages, @current_user)
        render json: messages_data
      end

      # POST /api/v1/conversations/:conversation_id/messages
      def create
        @message = @conversation.messages.build(
          user: @current_user,
          content: params[:text],
          message_type: 'text'
        )

        if @message.save
          message_data = MessageSerializer.serialize(@message, @current_user)
          render json: message_data, status: :created
        else
          render json: { 
            errors: @message.errors.full_messages 
          }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/messages/:id/read
      def mark_as_read
        message = @conversation.messages.find(params[:id])
        
        if message.user_id != @current_user.id
          message.update(read: true)
          render json: { message: 'Message marked as read' }
        else
          render json: { error: 'Cannot mark your own message as read' }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Message not found' }, status: :not_found
      end

      private

      def set_conversation
        @conversation = @current_user.conversations.find(params[:conversation_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Conversation not found' }, status: :not_found
      end

      def message_params
        params.require(:message).permit(:content, :message_type)
      end
    end
  end
end
