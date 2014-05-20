# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  time_limit_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#  state         :integer
#  then_price    :integer
#

class Order < ActiveRecord::Base
  has_many :order_details, dependent: :destroy
  belongs_to :user
  belongs_to :time_limit
  enum state: [:registered, :shipped, :arrived, :exchanged]

  accepts_nested_attributes_for :order_details, reject_if: proc { |attributes| attributes['quantity'].to_i.zero? }
end
