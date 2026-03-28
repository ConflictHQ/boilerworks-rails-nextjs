module Mutations
  class UpdateProduct < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :slug, String, required: false
    argument :category_id, ID, required: false

    field :ok, Boolean, null: false
    field :product, Types::ProductType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(id:, **attrs)
      require_auth!
      product = Product.find_by_uuid!(id)
      authorize(product, :update?)

      if attrs.key?(:category_id)
        cat_id = attrs.delete(:category_id)
        attrs[:category] = cat_id ? Category.find_by_uuid!(cat_id) : nil
      end

      if product.update(attrs.compact)
        { ok: true, product: product, errors: nil }
      else
        { ok: false, product: nil, errors: format_errors(product) }
      end
    end
  end
end
