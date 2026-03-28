module Types
  class CategoryType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String
    field :products_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def products_count
      object.products.count
    end
  end
end
