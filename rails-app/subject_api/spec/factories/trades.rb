FactoryBot.define do
  factory :trade do
    sequence(:item_name) { |n| "example#{n}_item" }
    sequence(:points)    { |n| "#{n * 100}" }
    association :seller
  end
end
