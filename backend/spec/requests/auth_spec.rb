require "rails_helper"

RSpec.describe "Auth API", type: :request do
  let(:user) { create(:user, email_address: "test@example.com", password: "password") }

  describe "POST /auth/login" do
    it "authenticates with valid credentials" do
      post "/auth/login", params: { email_address: user.email_address, password: "password" }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq("test@example.com")
      expect(response.cookies["session_id"]).to be_present
    end

    it "rejects invalid credentials" do
      post "/auth/login", params: { email_address: user.email_address, password: "wrong" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /auth/me" do
    it "returns current user when authenticated" do
      sign_in(user)
      get "/auth/me"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq("test@example.com")
    end

    it "returns 401 when not authenticated" do
      get "/auth/me"

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /auth/logout" do
    it "terminates the session" do
      sign_in(user)
      delete "/auth/logout"

      expect(response).to have_http_status(:ok)
    end
  end
end
