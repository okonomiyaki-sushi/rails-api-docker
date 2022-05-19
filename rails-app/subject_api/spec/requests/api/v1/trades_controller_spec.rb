require 'rails_helper'

RSpec.describe Api::V1::TradesController, type: :request do

  describe "not authenticated" do
    context "correct parameters" do
      it "response Unauthorized" do
        post "/api/v1/trades", params: { item_name: "example", points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(response_json["title"]).to eq "Unauthorized"
        expect(response_json["detail"]).to eq "Authentication failure"
      end
    end
  end

  describe "create trade" do
    before do
      # auth user
      post "/api/v1/users",    params: { email: "example@example.com", password: "example" }
      post "/api/v1/sessions", params: { email: "example@example.com", password: "example" }
    end
    context "no item_name" do
      it "response Bad Request" do
        post "/api/v1/trades", params: { points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Item name can't be blank"]
      end
    end
    context "no points" do
      it "response Bad Request" do
        post "/api/v1/trades", params: { item_name: "example_item" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Points can't be blank", "Points is not a number"]
      end
    end
    context "item_name is too long" do
      it "response Bad Request" do
        post "/api/v1/trades", params: { item_name: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456", points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Item name is too long (maximum is 255 characters)"]
      end
    end
    context "points are bigger than 10000" do
      it "response Bad Request" do
        post "/api/v1/trades", params: { item_name: "example_item", points: 10001 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Points must be less than or equal to 10000"]
      end
    end
    context "points minus value" do
      it "response Bad Request" do
        post "/api/v1/trades", params: { item_name: "example_item", points: -100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Points must be greater than or equal to 0"]
      end
    end
    context "correct parameters" do
      it "response Created" do
        post "/api/v1/trades", params: { item_name: "example_item", points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(response_json["title"]).to eq "Created"
        expect(response_json["detail"]).to eq "Created a trade"
      end
    end
  end

  describe "edit trade" do
    let!(:trade) { create(:trade, item_name: "edit_trade_item", points: 2000, seller: create(:seller, email: "edit@example.com", password: "example"))}
    let!(:other_trade) { create(:trade) }
    let!(:closed_trade) { create(:trade, item_name: "edit_trade_item", closed: true, seller: create(:seller, email: "closed@example.com", password: "example"))}
    let(:edited_trade) { Trade.find(trade.id) }
    before do
      # auth user
      post "/api/v1/sessions", params: { email: "edit@example.com", password: "example" }
    end
    context "no item_name" do
      it "response Success" do
        put "/api/v1/trades/#{trade.id}", params: { points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq "Update trade information"
        expect(edited_trade.item_name).to eq "edit_trade_item"
        expect(edited_trade.points).to eq 100
      end
    end
    context "no points" do
      it "response Success" do
        put "/api/v1/trades/#{trade.id}", params: { item_name: "example_item" }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq "Update trade information"
        expect(edited_trade.item_name).to eq "example_item"
        expect(edited_trade.points).to eq 2000
      end
    end
    context "item_name is too long" do
      it "response Bad Request" do
        put "/api/v1/trades/#{trade.id}", params: { item_name: "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456", points: 100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Item name is too long (maximum is 255 characters)"]
      end
    end
    context "points are bigger than 10000" do
      it "response Bad Request" do
        put "/api/v1/trades/#{trade.id}", params: { item_name: "example_item", points: 10001 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Points must be less than or equal to 10000"]
      end
    end
    context "points minus value" do
      it "response Bad Request" do
        put "/api/v1/trades/#{trade.id}", params: { item_name: "example_item", points: -100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Points must be greater than or equal to 0"]
      end
    end
    context "Other people's trade" do
      it "response Bad Request" do
        put "/api/v1/trades/#{other_trade.id}", params: { item_name: "example_item", points: -100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Other People's trade"]
        expect(edited_trade.item_name).to eq "edit_trade_item"
        expect(edited_trade.points).to eq 2000

      end
    end
    context "closed trade" do
      it "response Bad Request" do
        post "/api/v1/sessions", params: { email: "closed@example.com", password: "example" }
        put "/api/v1/trades/#{closed_trade.id}", params: { item_name: "example_item", points: -100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Already closed"]
        expect(edited_trade.item_name).to eq "edit_trade_item"
        expect(edited_trade.points).to eq 2000
      end
    end
    context "not exists trade" do
      it "response Not Found" do
        put "/api/v1/trades/99999", params: { item_name: "example_item", points: -100 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_json["title"]).to eq "Not Found"
        expect(response_json["detail"]).to eq  "Couldn't find Trade with 'id'=99999"
      end
    end
    context "correct parameters" do
      it "response Success" do
        put "/api/v1/trades/#{trade.id}", params: { item_name: "sample_item", points: 500 }
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq "Update trade information"
        expect(edited_trade.item_name).to eq "sample_item"
        expect(edited_trade.points).to eq 500
      end
    end
  end

  describe "delete trade" do
    let!(:trade) { create(:trade, item_name: "dalete_trade_item", seller: create(:seller, email: "delete@example.com", password: "example"))}
    let!(:other_trade) { create(:trade) }
    let!(:closed_trade) { create(:trade, item_name: "dalete_trade_item", closed: true, seller: create(:seller, email: "closed@example.com", password: "example"))}
    let(:check_closed_trade) { Trade.find_by(id: closed_trade.id) }
    let(:deleted_trade) { Trade.find_by(id: trade.id) }
    before do
      # auth user
      post "/api/v1/sessions", params: { email: "delete@example.com", password: "example" }
    end
    context "other People's trade" do
      it "response Bad Request" do
        delete "/api/v1/trades/#{other_trade.id}"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Other People's trade"]
        expect(deleted_trade.present?).to be_truthy
      end
    end
    context "closed trade" do
      it "response Bad Request" do
        post "/api/v1/sessions", params: { email: "closed@example.com", password: "example" }
        delete "/api/v1/trades/#{closed_trade.id}"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Already closed"]
        expect(check_closed_trade.present?).to be_truthy
      end
    end
    context "not exists trade" do
      it "response Not Found" do
        delete "/api/v1/trades/99999"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_json["title"]).to eq "Not Found"
        expect(response_json["detail"]).to eq  "Couldn't find Trade with 'id'=99999"
      end
    end
    context "delete success" do
      it "response Success" do
        delete "/api/v1/trades/#{trade.id}"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq  "Deleted trade"
        expect(deleted_trade.blank?).to be_truthy
      end
    end
  end

  describe "purchase trade" do
    let!(:trade) { create(:trade, item_name: "purchase_item", points: 2000, seller: create(:seller, email: "purchase@example.com", password: "example"))}
    let!(:buyer) { create(:user, email: "buyer@example.com", password: "example")}
    let!(:closed_trade) { create(:trade, item_name: "closed_item", closed: true, seller: create(:seller, email: "closed@example.com", password: "example"))}
    let(:purchase) { Purchase.find_by(trade_id: trade.id) }
    let(:purchase_trade) { Trade.find(trade.id) }
    before do
      # auth user
      post "/api/v1/sessions", params: { email: "buyer@example.com", password: "example" }
    end
    context "Current user is seller" do
      it "response Bad Request" do
        post "/api/v1/sessions", params: { email: "purchase@example.com", password: "example" }
        post "/api/v1/trades/#{trade.id}/purchase"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Current user is seller"]
      end
    end
    context "closed trade" do
      it "response Bad Request" do
        post "/api/v1/trades/#{closed_trade.id}/purchase"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:bad_request)
        expect(response_json["title"]).to eq "Bad Request"
        expect(response_json["detail"]).to eq ["Already closed"]
      end
    end
    context "not exists trade" do
      it "response Not Found" do
        post "/api/v1/trades/99999/purchase"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response_json["title"]).to eq "Not Found"
        expect(response_json["detail"]).to eq  "Couldn't find Trade with 'id'=99999"
      end
    end
    context "purchase" do
      it "response Success" do
        post "/api/v1/trades/#{trade.id}/purchase"
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response_json["title"]).to eq "Success"
        expect(response_json["detail"]).to eq "Purchased"
        expect(purchase_trade.closed).to be_truthy
        expect(purchase.buyer_id).to eq buyer.id
        expect(purchase.attributes.slice(:trade_id, :seller_id, :item_name, :points)).to eq trade.attributes.slice(:id, :seller_id, :item_name, :points)
      end
    end
  end

end
