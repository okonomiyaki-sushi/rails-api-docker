class User < ApplicationRecord
  has_secure_password
  after_initialize :set_default_values

  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, presence: true

  has_many :trades,    foreign_key: :seller_id
  has_many :was_trade, foreign_key: :seller_id, class_name: "Purchase"
  has_many :purchased, foreign_key: :buyer_id,  class_name: "Purchase"
  
  def set_default_values
    # 10,000 points by default
    self.ownerd_points ||= 10000
  end
end
