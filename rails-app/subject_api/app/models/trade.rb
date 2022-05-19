class Trade < ApplicationRecord
  validates :seller_id, presence: true
  validates :item_name, presence: true, length: { maximum: 255 }
  validates :points,    presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10000}

  belongs_to :seller, class_name: "User"
  has_one :purchase

  def self.do_edit(trade_params, current_user)
    is_error = false
    trade = nil

    begin
      ActiveRecord::Base.transaction do
        trade = Trade.lock.find(trade_params[:id])
        is_error = trade.check_before_update(current_user)
        raise ActiveRecord::Rollback if is_error

        trade.update!(trade_params)
      end
    rescue ActiveRecord::RecordNotFound
      raise
    rescue
      is_error = true
    end

    return is_error, trade
  end

  def self.purchase(trade_params, current_user)
    is_error = false
    trade = nil

    begin
      ActiveRecord::Base.transaction do
        trade = Trade.lock.find(trade_params[:id])
        is_error = trade.check_before_purchase(current_user)
        raise ActiveRecord::Rollback if is_error           

        purchase = Purchase.create!(trade.attributes.slice("seller_id", "item_name", "points").merge({ "buyer_id"=> current_user.id, "trade_id"=> trade.id }))

        # lock seller and buyer
        Purchase.joins(:seller, :buyer).where(purchases: { id: purchase.id }).lock.first
        # subtract buyer points
        User.where("id = ?", purchase.buyer.id).update_all("ownerd_points = ownerd_points - #{trade.points}")
        # add seller points
        User.where("id = ?", purchase.seller.id).update_all("ownerd_points = ownerd_points + #{trade.points}")
        # end of trade
        trade.update!(closed: true)
      end
    rescue ActiveRecord::RecordNotFound
      raise
    rescue
      is_error = true
    end

    return is_error, trade
  end

  def self.do_delete(trade_params, current_user)
    is_error = false
    trade = nil

    begin
      ActiveRecord::Base.transaction do
        trade = Trade.lock.find(trade_params[:id])
        is_error = trade.check_before_update(current_user)
        raise ActiveRecord::Rollback if is_error
        trade.destroy!
      end
    rescue ActiveRecord::RecordNotFound
      raise
    rescue
      is_error = true
    end
    
    return is_error, trade
  end

  def check_before_update(current_user)
    self.errors.add(:base, "Already closed")       if self.closed
    self.errors.add(:base, "Other People's trade") if self.seller_id != current_user.id
    self.errors.present? ? true : false
  end

  def check_before_purchase(current_user)
    self.errors.add(:base, "Already closed")         if self.closed
    self.errors.add(:base, "Current user is seller") if self.seller_id == current_user.id
    self.errors.present? ? true : false
  end

end
