class TransitionLog < ApplicationRecord
  belongs_to :workflow_instance
  belongs_to :transitioned_by, class_name: "User", optional: true

  validates :from_state, :to_state, presence: true

  after_create :readonly!

  default_scope { order(created_at: :asc) }
end
