class Api::V1::AvailabilitySerializer < ActiveModel::Serializer
  attributes :id, :date, :available, :created_at, :updated_at

  def date
    object.date.strftime('%Y-%m-%d')
  end

  def available
    object.available
  end
end 