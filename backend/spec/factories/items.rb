FactoryBot.define do
  factory :item do
    sequence(:name) { |n| "Item #{n}" }
    description { "A test item" }
    price { 19.99 }
    sequence(:slug) { |n| "item-#{n}" }
    uuid { SecureRandom.uuid }
  end
end
