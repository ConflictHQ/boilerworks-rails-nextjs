module Types
  class FieldErrorType < Types::BaseObject
    field :field, String, null: false
    field :messages, [String], null: false
  end
end
