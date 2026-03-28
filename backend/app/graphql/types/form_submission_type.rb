module Types
  class FormSubmissionType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :form_definition, Types::FormDefinitionType, null: false
    field :data, GraphQL::Types::JSON, null: false
    field :status, String, null: false
    field :validated_at, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
