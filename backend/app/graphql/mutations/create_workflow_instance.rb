module Mutations
  class CreateWorkflowInstance < BaseMutation
    argument :workflow_definition_slug, String, required: true

    field :ok, Boolean, null: false
    field :workflow_instance, Types::WorkflowInstanceType, null: true
    field :errors, [Types::FieldErrorType], null: true

    def resolve(workflow_definition_slug:)
      require_auth!
      wd = WorkflowDefinition.find_by!(slug: workflow_definition_slug)
      authorize(WorkflowInstance, :create?)

      instance = wd.workflow_instances.new(current_state: wd.initial_state)

      if instance.save
        { ok: true, workflow_instance: instance, errors: nil }
      else
        { ok: false, workflow_instance: nil, errors: format_errors(instance) }
      end
    end
  end
end
