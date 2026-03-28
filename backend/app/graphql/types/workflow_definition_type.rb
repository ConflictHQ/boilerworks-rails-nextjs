module Types
  class WorkflowDefinitionType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String
    field :states, GraphQL::Types::JSON, null: false
    field :transitions, GraphQL::Types::JSON, null: false
    field :target_type, String
    field :instances_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def instances_count
      object.workflow_instances.count
    end
  end
end
