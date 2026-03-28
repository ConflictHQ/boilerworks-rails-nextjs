Rails.application.routes.draw do
  # Auth endpoints
  post "auth/login", to: "api/sessions#create"
  delete "auth/logout", to: "api/sessions#destroy"
  get "auth/me", to: "api/sessions#me"

  # GraphQL
  post "graphql", to: "api/graphql#execute"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
