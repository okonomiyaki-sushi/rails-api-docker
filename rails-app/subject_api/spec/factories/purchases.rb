FactoryBot.define do
  factory :purchase do
    sequence(:trade_id)  { |n| "example#{n}_item" }
    sequence(:item_name) { |n| "testitem" }
    sequence(:points)    { |n| "#{n * 100}" }
    association :seller
    association :buyer
  end
end
