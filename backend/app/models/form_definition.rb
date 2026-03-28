class FormDefinition < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  has_many :form_submissions, dependent: :destroy

  STATUSES = %w[draft published archived].freeze

  validates :name, :slug, :status, presence: true
  validates :slug, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  scope :published, -> { where(status: "published") }
  scope :draft, -> { where(status: "draft") }

  def published? = status == "published"
  def draft? = status == "draft"
  def archived? = status == "archived"

  def publish!
    update!(status: "published")
  end

  def archive!
    update!(status: "archived")
  end

  def to_param
    uuid
  end

  def field_definitions
    schema["fields"] || []
  end
end
