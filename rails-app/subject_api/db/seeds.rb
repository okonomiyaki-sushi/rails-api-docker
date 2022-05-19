# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User
users = [
  { email: "example@example.com", password: "example_user", password_confirmation: "example_user" },
  { email: "test@example.com",    password: "test_user",    password_confirmation: "test_user" },
  { email: "sample@example.com",  password: "sample_user",  password_confirmation: "sample_user" }
]

users.each do |user|
  User.create(user)
end

#Trade
trades = [
  { seller_id: 1, item_name: "example_item", points: 100 },
  { seller_id: 2,    item_name: "test_item",    points: 200 },
  { seller_id: 3,  item_name: "sample_item",  points: 300 }
]

trades.each do |trade|
  Trade.create(trade)
end
