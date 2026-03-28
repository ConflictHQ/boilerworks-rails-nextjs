module Mutations
  class UpdateFormDefinition < BaseMutation
    argument :slug, String, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :schema, GraphQL::Types::JSON, required: false

    field :ok, Boolean, null: false
    field :form_definition, Types::FormDefinitionType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(slug:, **attrs)
      require_auth!
      fd = FormDefinition.find_by!(slug: slug)
      authorize(fd, :update?)

      if fd.update(attrs.compact)
        { ok: true, form_definition: fd, errors: nil }
      else
        { ok: false, form_definition: nil, errors: format_errors(fd) }
      end
    end
  end
end
