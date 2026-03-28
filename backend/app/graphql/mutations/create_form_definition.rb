module Mutations
  class CreateFormDefinition < BaseMutation
    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false
    argument :schema, GraphQL::Types::JSON, required: false

    field :ok, Boolean, null: false
    field :form_definition, Types::FormDefinitionType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(name:, slug:, description: nil, schema: nil)
      require_auth!
      authorize(FormDefinition, :create?)

      fd = FormDefinition.new(
        name: name,
        slug: slug,
        description: description,
        schema: schema || { "fields" => [] },
        status: "draft"
      )

      if fd.save
        { ok: true, form_definition: fd, errors: nil }
      else
        { ok: false, form_definition: nil, errors: format_errors(fd) }
      end
    end
  end
end
