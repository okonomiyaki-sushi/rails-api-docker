class Purchase < ApplicationRecord
  validates :trade_id,  presence: true
  validates :seller_id, presence: true
  validates :buyer_id,  presence: true
  validates :item_name, presence: true, length: { maximum: 255 }
  validates :points,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10000}
  
  belongs_to :seller, class_name: "User"
  belongs_to :buyer,  class_name: "User"
end
