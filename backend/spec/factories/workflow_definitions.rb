FactoryBot.define do
  factory :workflow_definition do
    sequence(:name) { |n| "Workflow #{n}" }
    sequence(:slug) { |n| "workflow-#{n}" }
    description { "A test workflow" }
    states do
      [
        { "name" => "draft", "initial" => true },
        { "name" => "review" },
        { "name" => "approved" },
        { "name" => "rejected" }
      ]
    end
    transitions do
      [
        { "from" => "draft", "to" => "review" },
        { "from" => "review", "to" => "approved" },
        { "from" => "review", "to" => "rejected" }
      ]
    end
    uuid { SecureRandom.uuid }
  end
end
