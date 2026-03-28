class Permission < ApplicationRecord
  has_and_belongs_to_many :groups

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
