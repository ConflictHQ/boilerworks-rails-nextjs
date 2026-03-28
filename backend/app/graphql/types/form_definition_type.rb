module Types
  class FormDefinitionType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String
    field :schema, GraphQL::Types::JSON, null: false
    field :status, String, null: false
    field :submissions_count, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def submissions_count
      object.form_submissions.count
    end
  end
end
