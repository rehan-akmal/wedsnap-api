module Api
  module V1
    class GigSerializer < ActiveModel::Serializer
      attributes :id, :title, :description, :location, :created_at, :updated_at, :user_name, :packages

      has_many :packages, serializer: Api::V1::PackageSerializer

      def user_name
        object.user.name
      end
    end
  end
end 