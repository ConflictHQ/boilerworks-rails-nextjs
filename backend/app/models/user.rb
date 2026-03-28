class User < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId

  has_secure_password
  has_many :sessions, dependent: :destroy
  has_and_belongs_to_many :groups
  has_many :permissions, through: :groups

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true

  def admin?
    return false if groups.empty?

    all_permission_ids = Permission.pluck(:id).to_set
    user_permission_ids = permissions.pluck(:id).to_set
    all_permission_ids.subset?(user_permission_ids)
  end

  def has_permission?(slug)
    permissions.exists?(slug: slug)
  end

  def display_name
    [first_name, last_name].compact.join(" ").presence || email_address
  end
end
