module Api
  class SessionsController < ApplicationController
    skip_before_action :require_authentication, only: [:create]

    def create
      user = User.authenticate_by(
        email_address: params[:email_address],
        password: params[:password]
      )

      if user
        start_new_session_for(user)
        render json: {
          user: {
            id: user.uuid,
            email: user.email_address,
            firstName: user.first_name,
            lastName: user.last_name,
            displayName: user.display_name
          }
        }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      terminate_session
      render json: { ok: true }, status: :ok
    end

    def me
      user = Current.user
      if user
        render json: {
          user: {
            id: user.uuid,
            email: user.email_address,
            firstName: user.first_name,
            lastName: user.last_name,
            displayName: user.display_name,
            permissions: user.permissions.pluck(:slug)
          }
        }, status: :ok
      else
        render json: { error: "Not authenticated" }, status: :unauthorized
      end
    end
  end
end
