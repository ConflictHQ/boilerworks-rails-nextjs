module Versionable
  extend ActiveSupport::Concern

  included do
    before_save :increment_lock_version, if: :changed?
  end

  private

  def increment_lock_version
    self.lock_version = (lock_version || 0) + 1 if persisted?
  end
end
