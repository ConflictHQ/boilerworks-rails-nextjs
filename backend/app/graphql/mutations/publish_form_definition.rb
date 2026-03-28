module Mutations
  class PublishFormDefinition < BaseMutation
    argument :slug, String, required: true

    field :ok, Boolean, null: false
    field :form_definition, Types::FormDefinitionType, null: true

    def resolve(slug:)
      require_auth!
      fd = FormDefinition.find_by!(slug: slug)
      authorize(fd, :update?)
      fd.publish!
      { ok: true, form_definition: fd }
    end
  end
end
