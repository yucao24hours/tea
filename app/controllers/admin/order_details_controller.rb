class Admin::OrderDetailsController < ApplicationController
  include Login
  before_action :need_logged_in

  def index
    @user  = User.find(params[:user_id])
    @items = Item.order(:id)
  end

  def create
    @user        = User.find(params[:user_id])
    order_detail = @user.order.order_details.create!(admin_order_detail_params)

    redirect_to admin_user_order_details_path(@user.id),
                flash: {success: "#{order_detail.item.name}を追加しました。"}

  rescue ActiveRecord::RecordInvalid => e
    @order_detail = e.record
    @items        = Item.order(:id)

    render :index
  end

  def destroy
    order_detail = OrderDetail.find(params[:id])

    OrderDetail.destroy order_detail

    redirect_to admin_user_order_details_path(order_detail.order.user),
                flash: {success: "#{order_detail.item.name}を削除しました。"}
  end

  private

  def admin_order_detail_params
    params.require(:order_detail).permit(:item_id, :quantity)
  end
end
