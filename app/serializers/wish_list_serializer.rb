class WishListSerializer < ActiveModel::Serializer
  attributes :id, :name, :winery, :size, :location, :vintage, :grape
end
