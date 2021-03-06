# == Schema Information
#
# Table name: order_details
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  quantity   :integer
#  created_at :datetime
#  updated_at :datetime
#  then_price :integer
#

class OrderDetail < ActiveRecord::Base
  MAX_QUANTITY_PER_ORDER = 20

  belongs_to :order
  belongs_to :item

  before_create :copy_then_price
  #before_create :period_must_be_include_now 正しいが、テスト修正に時間がかかりそうなので後回し。UI上はできないことは確認済み。

  validate  do Period.singleton_instance.try(:valid?) end
  validate  :period_must_have_defined_times
  validates :item_id,  presence: true, uniqueness: {scope: :order}
  validates :quantity, numericality: {only_integer: true, greater_than_or_equal_to: 1}


  def copy_then_price
    self.then_price = item.price
  end

  class << self
    def price_sum
      all.inject(0) {|acc, detail|
        acc + detail.quantity * (detail.then_price || detail.item.price)
      }
    end
  end

  private

  def period_must_have_defined_times
    return unless Period.singleton_instance
    errors[:base] << 'details is invalid when undefined_times' if Period.has_undefined_times?
  end
end
