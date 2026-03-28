module Mutations
  class UpdateWorkflowDefinition < BaseMutation
    argument :slug, String, required: true
    argument :name, String, required: false
    argument :description, String, required: false
    argument :states, GraphQL::Types::JSON, required: false
    argument :transitions, GraphQL::Types::JSON, required: false

    field :ok, Boolean, null: false
    field :workflow_definition, Types::WorkflowDefinitionType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(slug:, **attrs)
      require_auth!
      wd = WorkflowDefinition.find_by!(slug: slug)
      authorize(wd, :update?)

      if wd.update(attrs.compact)
        { ok: true, workflow_definition: wd, errors: nil }
      else
        { ok: false, workflow_definition: nil, errors: format_errors(wd) }
      end
    end
  end
end
