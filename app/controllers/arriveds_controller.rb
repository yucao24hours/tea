class ArrivedsController < ApplicationController
  def show
    @orders = Order.includes(:user, order_details: :item).arrived
  end

  def exchange
    exchanged_order_count = Order.where(id: params[:order_ids]).update_all(state: Order.states[:exchanged])

    if exchanged_order_count.zero?
      redirect_to action: :show
    else
      flash[:success] = '引換したことを登録しました。'
      redirect_to exchanged_path
    end
  end
end
