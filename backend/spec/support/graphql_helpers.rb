module GraphQLHelpers
  def graphql_query(query, variables: {}, user: nil)
    if user
      post "/auth/login", params: {
        email_address: user.email_address,
        password: "password"
      }
    end

    post "/graphql",
      params: { query: query, variables: variables.to_json }.to_json,
      headers: { "Content-Type" => "application/json" }
  end

  def json_response
    JSON.parse(response.body)
  end

  def graphql_data
    json_response["data"]
  end

  def graphql_errors
    json_response["errors"]
  end
end

RSpec.configure do |config|
  config.include GraphQLHelpers, type: :request
end
