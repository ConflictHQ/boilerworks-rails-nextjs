class ApplicationController < ActionController::API
  include ActionController::Cookies
  include Authentication
  include Pundit::Authorization
  include SetCurrentAttributes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    Current.user
  end

  private

  def user_not_authorized
    render json: { error: "Not authorized" }, status: :forbidden
  end
end
