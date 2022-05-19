require 'rails_helper'

RSpec.describe Trade, type: :model do
  describe "#Trade create" do
    let!(:user) { create(:user) }

    context "no seller" do
      it "validation error" do
        trade = build(:trade, seller_id: nil)
        trade.valid?
        expect(trade.errors.full_messages).to eq ["Seller can't be blank", "Seller must exist"]
      end
    end
    context "no item_name" do
      it "validation error" do
        trade = build(:trade, seller_id: user.id, item_name: nil)
        trade.valid?
        expect(trade.errors.full_messages).to eq ["Item name can't be blank"]
      end
    end
    context "no points" do
      it "validation error" do
        trade = build(:trade, seller_id: user.id, points: nil)
        trade.valid?
        expect(trade.errors.full_messages).to eq ["Points can't be blank", "Points is not a number"]
      end
    end
    context "points are bigger than 10000" do
      it "validation error" do
        trade = build(:trade, seller_id: user.id, points: 10001)
        trade.valid?
        expect(trade.errors.full_messages).to eq ["Points must be less than or equal to 10000"]
      end
    end
    context "correct parameters" do
      it "validation success" do
        trade = create(:trade)
        expect(trade).to be_valid
      end
    end

  end
  
  describe "#Trade.purchase Check if trade is locked" do
    let!(:trade)  { create(:trade, points: 100) }
    let!(:buyer1) { create(:user) }
    let!(:buyer2) { create(:user) }
    let!(:buyer3) { create(:user) }
    
    context "When 3 users purchase at the same time" do
      is_error1, is_error2, is_error3, t1, t2, t3 = nil
      before do
        threads = []
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error1, t1 = Trade.purchase({ id: trade.id }, buyer1)
          end
        end
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error2, t2 = Trade.purchase({ id: trade.id }, buyer2)
          end
        end
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error3, t3 = Trade.purchase({ id: trade.id }, buyer3)
          end
        end
        threads.each(&:join)
      end
      it "exclusive control of points" do
        # get buyer
        buyer = nil
        no_buyer1 = nil
        no_buyer2 = nil
        unless is_error1
          buyer = User.find(buyer1.id)
          no_buyer1 = User.find(buyer2.id)
          no_buyer2 = User.find(buyer3.id)
        end
        unless is_error2
          buyer = User.find(buyer2.id)
          no_buyer1 = User.find(buyer1.id)
          no_buyer2 = User.find(buyer3.id)
        end
        unless is_error3
          buyer = User.find(buyer3.id)
          no_buyer1 = User.find(buyer1.id)
          no_buyer2 = User.find(buyer2.id)
        end
        
        seller = Trade.find(trade.id).seller
        
        expect([is_error1, is_error2, is_error3].one? { |v| v == false }).to be_truthy
        expect(buyer.ownerd_points).to eq 9900
        expect(seller.ownerd_points).to eq 10100
        expect(no_buyer1.ownerd_points).to eq 10000
        expect(no_buyer2.ownerd_points).to eq 10000
      end
    end
  end

  describe "#Trade purchase Check if user is locked" do
    let!(:trade1) { create(:trade, points: 100) }
    let!(:trade2) { create(:trade, points: 500) }
    let!(:trade3) { create(:trade, points: 800) }
    
    context "When 3 users purchase the same trade at the same time" do
      is_error1, is_error2, is_error3, t1, t2, t3 = nil
      before do
        threads = []
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error1, t1 = Trade.purchase({ id: trade1.id }, trade3.seller)
          end
        end
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error2, t2 = Trade.purchase({ id: trade2.id }, trade1.seller)
          end
        end
        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            is_error3, t3 = Trade.purchase({ id: trade3.id }, trade2.seller)
          end
        end
        threads.each(&:join)
      end
      it "exclusive control of points" do
        # get buyer
        user1 = User.find(trade1.seller.id)
        user2 = User.find(trade2.seller.id)
        user3 = User.find(trade3.seller.id)

        expect([is_error1, is_error2, is_error3].all? { |v| v == false }).to be_truthy
        expect(user1.ownerd_points).to eq 9600
        expect(user2.ownerd_points).to eq 9700
        expect(user3.ownerd_points).to eq 10700
      end
    end
  end














end