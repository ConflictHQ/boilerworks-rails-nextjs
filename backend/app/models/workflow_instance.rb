class WorkflowInstance < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  belongs_to :workflow_definition
  belongs_to :workflowable, polymorphic: true, optional: true
  has_many :transition_logs, dependent: :destroy

  validates :current_state, presence: true

  def to_param
    uuid
  end

  def available_transitions
    workflow_definition.transitions_from(current_state)
  end

  def can_transition_to?(state)
    available_transitions.any? { |t| t["to"] == state }
  end
end
