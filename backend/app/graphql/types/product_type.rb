module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :name, String, null: false
    field :slug, String
    field :description, String
    field :price, Float
    field :category, Types::CategoryType
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
