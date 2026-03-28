module Types
  class TransitionLogType < Types::BaseObject
    field :id, ID, null: false
    field :from_state, String, null: false
    field :to_state, String, null: false
    field :data, GraphQL::Types::JSON
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
