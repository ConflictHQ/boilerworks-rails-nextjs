module Mutations
  class UpdateCategory < BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :description, String, required: false

    field :ok, Boolean, null: false
    field :category, Types::CategoryType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(id:, **attrs)
      require_auth!
      category = Category.find_by_uuid!(id)
      authorize(category, :update?)

      if category.update(attrs.compact)
        { ok: true, category: category, errors: nil }
      else
        { ok: false, category: nil, errors: format_errors(category) }
      end
    end
  end
end
