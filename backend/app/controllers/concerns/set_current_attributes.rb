module SetCurrentAttributes
  extend ActiveSupport::Concern

  included do
    before_action :set_current_attributes
  end

  private

  def set_current_attributes
    Current.request_id = request.request_id
  end
end
