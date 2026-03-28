module Mutations
  class CreateProduct < BaseMutation
    argument :name, String, required: true
    argument :description, String, required: false
    argument :price, Float, required: false
    argument :slug, String, required: false
    argument :category_id, ID, required: false

    field :ok, Boolean, null: false
    field :product, Types::ProductType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(name:, description: nil, price: nil, slug: nil, category_id: nil)
      require_auth!
      authorize(Product, :create?)

      category = category_id ? Category.find_by_uuid!(category_id) : nil
      product = Product.new(name: name, description: description, price: price, slug: slug, category: category)

      if product.save
        { ok: true, product: product, errors: nil }
      else
        { ok: false, product: nil, errors: format_errors(product) }
      end
    end
  end
end
