class Group < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions

  validates :name, presence: true, uniqueness: true
end
