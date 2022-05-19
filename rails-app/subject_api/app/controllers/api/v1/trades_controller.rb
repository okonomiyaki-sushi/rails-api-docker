module Api
  module V1
    class TradesController < ApplicationController
      before_action :check_token

      # POST /api/v1/trades
      def create
        trade_params = params.permit(:item_name, :points).merge(seller_id: @user.id)
        trade = Trade.new(trade_params)
        if trade.save
          response_created("Created a trade") and return
        else
          response_bad_request(trade.errors.full_messages) and return
        end
      end

      # PUT /api/v1/trades/:id
      def update
        trade_params = params.permit(:id, :item_name, :points)
        is_error, trade = Trade.do_edit(trade_params, @user)
        if is_error
          response_bad_request(trade.errors.full_messages) and return
        else
          response_success("Update trade information") and return
        end
      end

      # POST /api/v1/trades/:id/purchase
      def purchase
        trade_params = params.permit(:id)
        is_error, trade = Trade.purchase(trade_params, @user)
        if is_error
          response_bad_request(trade.errors.full_messages) and return
        else
          response_success("Purchased") and return
        end
      end

      # DELETE /api/v1/trades/:id
      def destroy
        trade_params = params.permit(:id)
        is_error, trade = Trade.do_delete(trade_params, @user)
        if is_error
          response_bad_request(trade.errors.full_messages) and return
        else
          response_success("Deleted trade") and return
        end
      end

    end
  end
end
