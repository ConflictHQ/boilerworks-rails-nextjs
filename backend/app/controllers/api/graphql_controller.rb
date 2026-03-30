module Api
  class GraphqlController < ApplicationController
    # Skip the 401 guard — schema handles auth per resolver.
    # Still resume the session so Current.user is populated for authenticated requests.
    skip_before_action :require_authentication
    before_action :resume_session

    def execute
      variables = prepare_variables(params[:variables])
      query = params[:query]
      operation_name = params[:operationName]
      context = {
        current_user: Current.user,
        session: Current.session
      }
      result = BoilerworksSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
      render json: result
    rescue StandardError => e
      raise e unless Rails.env.development?

      handle_error_in_development(e)
    end

    private

    def prepare_variables(variables_param)
      case variables_param
      when String
        if variables_param.present?
          JSON.parse(variables_param) || {}
        else
          {}
        end
      when Hash
        variables_param
      when ActionController::Parameters
        variables_param.to_unsafe_hash
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{variables_param}"
      end
    end

    def handle_error_in_development(e)
      logger.error e.message
      logger.error e.backtrace.join("\n")

      render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: :internal_server_error
    end
  end
end
