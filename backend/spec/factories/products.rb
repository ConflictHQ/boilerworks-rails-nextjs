FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { "A test product" }
    price { 19.99 }
    sequence(:slug) { |n| "product-#{n}" }
    uuid { SecureRandom.uuid }
  end
end
