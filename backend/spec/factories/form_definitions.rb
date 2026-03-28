FactoryBot.define do
  factory :form_definition do
    sequence(:name) { |n| "Form #{n}" }
    sequence(:slug) { |n| "form-#{n}" }
    description { "A test form definition" }
    schema { { "fields" => [{ "name" => "full_name", "type" => "text", "required" => true }] } }
    status { "draft" }
    uuid { SecureRandom.uuid }

    trait :published do
      status { "published" }
    end

    trait :archived do
      status { "archived" }
    end
  end
end
