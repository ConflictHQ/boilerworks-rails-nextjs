module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, method: :uuid
    field :email, String, null: false, method: :email_address
    field :first_name, String
    field :last_name, String
    field :display_name, String, null: false
    field :permissions, [String], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false

    def permissions
      object.permissions.pluck(:slug)
    end
  end
end
