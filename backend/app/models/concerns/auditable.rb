module Auditable
  extend ActiveSupport::Concern

  included do
    belongs_to :created_by, class_name: "User", optional: true
    belongs_to :updated_by, class_name: "User", optional: true

    before_create { self.created_by ||= Current.user }
    before_save   { self.updated_by = Current.user }
  end
end
