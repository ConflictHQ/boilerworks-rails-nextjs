class BoilerworksSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # GraphQL-Ruby security limits
  max_query_string_tokens 5000
  validate_max_errors 100

  # Disable introspection in production
  disable_introspection_entry_points if Rails.env.production?

  rescue_from(Pundit::NotAuthorizedError) { raise GraphQL::ExecutionError, "Not authorized" }

  def self.unauthorized_object(error)
    raise GraphQL::ExecutionError, "Not authorized to access #{error.type.graphql_name}"
  end

  def self.unauthorized_field(error)
    raise GraphQL::ExecutionError, "Not authorized to access #{error.field.graphql_name}"
  end
end
