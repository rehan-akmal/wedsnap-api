module Api
  module V1
    class FeatureSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end 