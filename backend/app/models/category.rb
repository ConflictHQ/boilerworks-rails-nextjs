class Category < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id"
  has_many :items

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  def to_param
    uuid
  end
end
