module Mutations
  class CreateWorkflowDefinition < BaseMutation
    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: false
    argument :states, GraphQL::Types::JSON, required: true
    argument :transitions, GraphQL::Types::JSON, required: true
    argument :target_type, String, required: false

    field :ok, Boolean, null: false
    field :workflow_definition, Types::WorkflowDefinitionType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(name:, slug:, states:, transitions:, description: nil, target_type: nil)
      require_auth!
      authorize(WorkflowDefinition, :create?)

      wd = WorkflowDefinition.new(
        name: name,
        slug: slug,
        description: description,
        states: states,
        transitions: transitions,
        target_type: target_type
      )

      if wd.save
        { ok: true, workflow_definition: wd, errors: nil }
      else
        { ok: false, workflow_definition: nil, errors: format_errors(wd) }
      end
    end
  end
end
