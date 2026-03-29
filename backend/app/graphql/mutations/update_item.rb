module Mutations
  class UpdateItem < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :slug, String, required: false
    argument :category_id, ID, required: false

    field :ok, Boolean, null: false
    field :item, Types::ItemType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(id:, **attrs)
      require_auth!
      item = Item.find_by_uuid!(id)
      authorize(item, :update?)

      if attrs.key?(:category_id)
        cat_id = attrs.delete(:category_id)
        attrs[:category] = cat_id ? Category.find_by_uuid!(cat_id) : nil
      end

      if item.update(attrs.compact)
        { ok: true, item: item, errors: nil }
      else
        { ok: false, item: nil, errors: format_errors(item) }
      end
    end
  end
end
