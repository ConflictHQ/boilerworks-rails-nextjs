module SoftDeletable
  extend ActiveSupport::Concern

  included do
    belongs_to :deleted_by, class_name: "User", optional: true
    default_scope { where(deleted_at: nil) }
    scope :with_deleted, -> { unscope(where: :deleted_at) }
    scope :only_deleted, -> { unscope(where: :deleted_at).where.not(deleted_at: nil) }
  end

  def soft_delete!
    update!(deleted_at: Time.current, deleted_by: Current.user)
  end

  def restore!
    update!(deleted_at: nil, deleted_by: nil)
  end

  def deleted?
    deleted_at.present?
  end
end
