class WorkflowDefinition < ApplicationRecord
  include Auditable, SoftDeletable, ExternalId, Versionable

  has_many :workflow_instances, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  def to_param
    uuid
  end

  def state_names
    states.map { |s| s["name"] }
  end

  def initial_state
    states.find { |s| s["initial"] }&.dig("name") || states.first&.dig("name")
  end

  def transitions_from(state)
    transitions.select { |t| t["from"] == state }
  end

  def find_transition(from, to)
    transitions.find { |t| t["from"] == from && t["to"] == to }
  end
end
