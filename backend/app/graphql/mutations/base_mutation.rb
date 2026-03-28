module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    object_class Types::BaseObject

    private

    def require_auth!
      raise GraphQL::ExecutionError.new("Authentication required", extensions: { code: "UNAUTHENTICATED" }) unless context[:current_user]
    end

    def authorize(record, action)
      Pundit.authorize(context[:current_user], record, action)
    rescue Pundit::NotAuthorizedError
      raise GraphQL::ExecutionError, "Not authorized"
    end

    def format_errors(record)
      record.errors.map do |error|
        { field: error.attribute.to_s.camelize(:lower), messages: [error.full_message] }
      end
    end
  end
end
