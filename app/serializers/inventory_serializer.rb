class InventorySerializer < ActiveModel::Serializer
  attributes :id, :name, :winery, :size, :location, :vintage, :grape, :quantity
end
