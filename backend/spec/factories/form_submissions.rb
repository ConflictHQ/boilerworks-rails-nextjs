FactoryBot.define do
  factory :form_submission do
    form_definition
    data { { "full_name" => "Jane Doe" } }
    status { "submitted" }
    validated_at { Time.current }
    uuid { SecureRandom.uuid }
  end
end
