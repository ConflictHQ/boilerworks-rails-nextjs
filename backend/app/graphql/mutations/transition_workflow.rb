module Mutations
  class TransitionWorkflow < BaseMutation
    argument :id, ID, required: true
    argument :to_state, String, required: true

    field :ok, Boolean, null: false
    field :workflow_instance, Types::WorkflowInstanceType, null: true

    def resolve(id:, to_state:)
      require_auth!
      instance = WorkflowInstance.find_by_uuid!(id)
      authorize(instance, :update?)

      unless instance.can_transition_to?(to_state)
        raise GraphQL::ExecutionError, "Cannot transition from #{instance.current_state} to #{to_state}"
      end

      from_state = instance.current_state

      ActiveRecord::Base.transaction do
        instance.update!(current_state: to_state)
        instance.transition_logs.create!(
          from_state: from_state,
          to_state: to_state,
          transitioned_by: context[:current_user]
        )
      end

      { ok: true, workflow_instance: instance }
    end
  end
end
