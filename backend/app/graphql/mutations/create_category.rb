module Mutations
  class CreateCategory < BaseMutation
    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false

    field :ok, Boolean, null: false
    field :category, Types::CategoryType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(name:, slug:, description: nil)
      require_auth!
      authorize(Category, :create?)

      category = Category.new(name: name, slug: slug, description: description)

      if category.save
        { ok: true, category: category, errors: nil }
      else
        { ok: false, category: nil, errors: format_errors(category) }
      end
    end
  end
end
