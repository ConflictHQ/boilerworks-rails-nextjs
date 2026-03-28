FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password" }
    first_name { "Test" }
    last_name { "User" }
    uuid { SecureRandom.uuid }

    trait :admin do
      after(:create) do |user|
        admin_group = Group.find_or_create_by!(name: "admin") do |g|
          Permission.find_each { |p| g.permissions << p unless g.permissions.include?(p) }
        end
        user.groups << admin_group unless user.groups.include?(admin_group)
      end
    end

    trait :with_product_permissions do
      after(:create) do |user|
        group = Group.find_or_create_by!(name: "product-editors")
        %w[product.view product.add product.change product.delete].each do |slug|
          perm = Permission.find_or_create_by!(slug: slug) { |p| p.name = slug.titleize }
          group.permissions << perm unless group.permissions.include?(perm)
        end
        user.groups << group unless user.groups.include?(group)
      end
    end

    trait :with_all_permissions do
      after(:create) do |user|
        group = Group.find_or_create_by!(name: "full-access")
        %w[
          product.view product.add product.change product.delete
          category.view category.add category.change category.delete
          form.view form.add form.change form.delete
          workflow.view workflow.add workflow.change workflow.delete
        ].each do |slug|
          perm = Permission.find_or_create_by!(slug: slug) { |p| p.name = slug.titleize }
          group.permissions << perm unless group.permissions.include?(perm)
        end
        user.groups << group unless user.groups.include?(group)
      end
    end
  end
end
