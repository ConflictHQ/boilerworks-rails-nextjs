module ExternalId
  extend ActiveSupport::Concern

  included do
    before_create { self.uuid ||= SecureRandom.uuid }
    validates :uuid, uniqueness: true, allow_nil: true
  end

  class_methods do
    def find_by_uuid!(uuid)
      find_by!(uuid: uuid)
    end
  end
end
