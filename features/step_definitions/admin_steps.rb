Given /^引換用ページにいる$/ do
  visit '/orders/arrived'
end

When /^注文をネスレに発注する$/ do
  visit '/orders/registered'
  # NOTE ここで管理者が手動操作によりネスレのサイトからお茶を注文するステップが入る。
  #      それが完了したことをシステムとして登録するのが以下のステップである。
  click_button '発注の完了をシステムに登録'
end

When /^お茶が発送されたことを登録する$/ do
  visit '/orders/ordered'
  click_button 'お茶の受領をシステムに登録'
end

When /^"(.*?)"の引換完了チェックにチェックを入れる$/ do |user_name|
  check "user_#{User.find_by(name: "Alice").id}"
end

When /^注文期限がきれるまで待つ$/ do
  wait_untill_period_become_out_of_date
end

# FIXME
#本当は「明細表のｘ行目のｙはｚであること」みたいにしたい。
#でもそれだとorder_detailを消した時、n行目の行がid n であるという対応が崩れて間違いになる。
Then /^"(.*?)"番目に作った明細は、明細表で"(.*?)"が"(.*?)"であること$/ do |id, col_name, expected|
  within('#order_details_index_table') do
    within(".order_detail_#{id}") do
      td_text = find(to_class_in_details_table(col_name)).text
      expect(td_text).to eq expected
    end
  end
end

Then /^ネスレ発送待ち商品の確認用のページに飛ぶこと$/ do
  expect(page.current_path).to eq '/orders/ordered'
end

Then /^引換用ページに飛ぶこと$/ do
  expect(page.current_path).to eq '/orders/arrived'
end

Then /^引換済み商品ページに飛ぶこと$/ do
  expect(page.current_path)
end

もし(/^ネスレに発注する商品一覧を見る$/) do
  within "#menu" do
    click_link "ネスレ入力用ページ"
  end
end

module StepDefinitionsUtil
  #日→英だし、step以外では使わないのでI18でやらないことにする
  def to_class_in_details_table(col_name)
    case col_name
    when '品名'
      '.name'
    when '数量'
      '.quantity'
    when '単価'
      '.price'
    when '小計'
      '.sum'
    when ''
      '.destroy'
    else
      raise "pass invalid arg '#{col_name}' to #{__method__}"
    end
  end

  def to_class_in_aggregate_table(col_name)
    case col_name
    when '商品名'
      '.name'
    when '単価'
      '.price'
    when '合計数量'
      '.sum'
    else
      raise "pass invalid arg '#{col_name}' to #{__method__}"
    end
  end

  def get_user_name_from_header!
    within('header') do
      match_data = find('#greeting').text.match /^こんにちは(.*?)さん$/
      match_data[1]
    end
  rescue
    raise 'ヘッダーから名前を取得できません。'
  end

  def detail_id_from_item_name!(item_name)
    item = Item.find_by!(name: item_name)
    OrderDetail.find_by!(item: item).id
  end

  def raise_error_if_wrong_price_passed(item_name, price)
    price_in_db = Item.find_by(name: item_name).price
    unless  price_in_db == price.to_i
      raise "must pass price same as #{price_in_db}, which price_in_db"
    end
  end
end
include StepDefinitionsUtil
