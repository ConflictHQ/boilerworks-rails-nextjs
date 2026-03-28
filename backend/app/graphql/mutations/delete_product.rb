module Mutations
  class DeleteProduct < BaseMutation
    argument :id, ID, required: true

    field :ok, Boolean, null: false

    def resolve(id:)
      require_auth!
      product = Product.find_by_uuid!(id)
      authorize(product, :destroy?)
      product.soft_delete!
      { ok: true }
    end
  end
end
