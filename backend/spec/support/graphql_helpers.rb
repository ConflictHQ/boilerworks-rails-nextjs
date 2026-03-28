module GraphQLHelpers
  def graphql_query(query, variables: {}, user: nil)
    if user
      session = user.sessions.create!(ip_address: "127.0.0.1", user_agent: "RSpec")
      Current.session = session
      cookies[:session_id] = session.id
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
