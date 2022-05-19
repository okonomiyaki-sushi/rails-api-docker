FactoryBot.define do
  factory :user, aliases: [:seller, :buyer] do
    sequence(:email)    { |n| "example#{n}@example.com" }
    sequence(:password) { |n| "example#{n}" }
  end
end
