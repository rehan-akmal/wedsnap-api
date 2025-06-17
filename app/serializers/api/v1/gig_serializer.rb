module Api
  module V1
    class GigSerializer < ActiveModel::Serializer
      attributes :id, :title, :description, :location, :created_at, :updated_at, :user_name, :user_id, :images

      has_many :packages, serializer: Api::V1::PackageSerializer
      has_many :features
      has_many :faqs
      has_many :categories
      # has_many :orders

      def user_name
        object.user.name
      end
      
      def user_id
        object.user.id
      end

      def seller
        object.user
      end

      def images
        return [] unless object.images.attached?
        
        object.images.map do |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
        end
      end
    end
  end
end 