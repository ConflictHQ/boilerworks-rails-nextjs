class Product < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  belongs_to :category, optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :slug, uniqueness: true, allow_nil: true

  def to_param
    uuid
  end
end
