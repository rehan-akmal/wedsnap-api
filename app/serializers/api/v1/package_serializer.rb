module Api
  module V1
    class PackageSerializer < ActiveModel::Serializer
      attributes :id, :name, :description, :price, :delivery_days, :revisions, :created_at, :updated_at
    end
  end
end 