module Api
  module V1
    class FaqSerializer < ActiveModel::Serializer
      attributes :id, :question, :answer
    end
  end
end 