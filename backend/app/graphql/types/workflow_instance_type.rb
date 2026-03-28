module Types
  class WorkflowInstanceType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :workflow_definition, Types::WorkflowDefinitionType, null: false
    field :current_state, String, null: false
    field :metadata, GraphQL::Types::JSON
    field :available_transitions, GraphQL::Types::JSON, null: false
    field :transition_logs, [Types::TransitionLogType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
