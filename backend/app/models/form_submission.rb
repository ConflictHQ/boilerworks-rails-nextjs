class FormSubmission < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  belongs_to :form_definition
  belongs_to :submitted_by, class_name: "User", optional: true

  STATUSES = %w[draft submitted in_review approved rejected].freeze

  validates :status, inclusion: { in: STATUSES }

  def submit!
    update!(status: "submitted", validated_at: Time.current)
  end

  def approve!
    update!(status: "approved")
  end

  def reject!
    update!(status: "rejected")
  end

  def to_param
    uuid
  end
end
