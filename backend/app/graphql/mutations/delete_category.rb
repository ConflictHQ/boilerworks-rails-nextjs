module Mutations
  class DeleteCategory < BaseMutation
    argument :id, ID, required: true

    field :ok, Boolean, null: false

    def resolve(id:)
      require_auth!
      category = Category.find_by_uuid!(id)
      authorize(category, :destroy?)
      category.soft_delete!
      { ok: true }
    end
  end
end
