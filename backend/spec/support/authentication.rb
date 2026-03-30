module AuthenticationHelpers
  def sign_in(user)
    post "/auth/login", params: {
      email_address: user.email_address,
      password: "password"
    }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end
