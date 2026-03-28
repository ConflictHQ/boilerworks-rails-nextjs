FactoryBot.define do
  factory :permission do
    sequence(:name) { |n| "Permission #{n}" }
    sequence(:slug) { |n| "resource.action#{n}" }
  end
end
