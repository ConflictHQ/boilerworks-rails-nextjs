module Mutations
  class DeleteItem < BaseMutation
    argument :id, ID, required: true

    field :ok, Boolean, null: false

    def resolve(id:)
      require_auth!
      item = Item.find_by_uuid!(id)
      authorize(item, :destroy?)
      item.soft_delete!
      { ok: true }
    end
  end
end
