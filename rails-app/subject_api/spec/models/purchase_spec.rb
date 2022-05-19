require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe "#Purchase create" do
    let!(:seller) { create(:user) }
    let!(:buyer)  { create(:user) }
    
    context "no seller" do
      it "validation error" do
        purchase = build(:purchase, seller_id: nil, buyer_id: buyer.id)
        purchase.valid?
        expect(purchase.errors.full_messages).to eq ["Seller can't be blank", "Seller must exist"]
      end
    end
    context "no buyer" do
      it "validation error" do
        purchase = build(:purchase, seller_id: seller.id, buyer_id: nil)
        purchase.valid?
        expect(purchase.errors.full_messages).to eq ["Buyer can't be blank", "Buyer must exist"]
      end
    end
    context "no item_name" do
      it "validation error" do
        purchase = build(:purchase, seller_id: seller.id, buyer_id: buyer.id, item_name: nil)
        purchase.valid?
        expect(purchase.errors.full_messages).to eq ["Item name can't be blank"]
      end
    end
    context "no points" do
      it "validation error" do
        purchase = build(:purchase, seller_id: seller.id, buyer_id: buyer.id, points: nil)
        purchase.valid?
        expect(purchase.errors.full_messages).to eq ["Points can't be blank", "Points is not a number"]
      end
    end
    context "points are bigger than 10000" do
      it "validation error" do
        purchase = build(:purchase, seller_id: seller.id, buyer_id: buyer.id, points: 10001)
        purchase.valid?
        expect(purchase.errors.full_messages).to eq ["Points must be less than or equal to 10000"]
      end
    end
    context "correct parameters" do
      it "validation success" do
        purchase = create(:purchase)
        expect(purchase).to be_valid
      end
    end

  end
end
