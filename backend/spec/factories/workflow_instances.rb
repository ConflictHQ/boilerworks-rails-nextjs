FactoryBot.define do
  factory :workflow_instance do
    workflow_definition
    current_state { "draft" }
    uuid { SecureRandom.uuid }
  end
end
