module Mutations
  class CreateItem < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :slug, String, required: false
    argument :category_id, ID, required: false

    field :ok, Boolean, null: false
    field :item, Types::ItemType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(name:, description: nil, price: nil, slug: nil, category_id: nil)
      require_auth!
      authorize(Item, :create?)

      category = category_id ? Category.find_by_uuid!(category_id) : nil
      item = Item.new(name: name, description: description, price: price, slug: slug, category: category)

      if item.save
        { ok: true, item: item, errors: nil }
      else
        { ok: false, item: nil, errors: format_errors(item) }
      end
    end
  end
end
