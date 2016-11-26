Given /^"(.*?)"円のお茶"(.*?)"を"(.*?)"個注文している$/ do |price, item_name, quantity|
  raise_error_if_wrong_price_passed(item_name, price)

  choose_item_and_quantity(item_name, quantity)
  click_button '追加する'
end

Given /^ユーザー"(.*?)"が"(.*?)"円のお茶"(.*?)"を"(.*?)"個注文している$/ do |user_name, price, item_name, quantity|
  step %Q{ユーザー"#{user_name}"がログインしている}
  step %Q{"#{price}"円のお茶"#{item_name}"を"#{quantity}"個注文している}
  step %Q{ユーザー"#{user_name}"がログアウトする}
end

When /^注文画面を表示する$/ do
  visit '/order_details'
end

When /^品名"(.*?)"を選ぶ$/ do |item_name|
  choose_item item_name
end

When /^数量"(.*?)"を選ぶ$/ do |quantity|
  choose_quantity quantity
end

When /^品名"(.*?)"の削除リンクをクリックする$/ do |item_name|
  row_index = detail_id_from_item_name!(item_name)
  within('#order_details_index_table') do
    within(".order_detail_#{row_index}") do
      click_link '削除'
    end
  end
end

Then /^明細表が以下になること$/ do |table|
  table.hashes.each do |row|
    id = detail_id_from_item_name!(row['品名'])
    row.keys.each do |col_name|
      step %Q{"#{id}"番目に作った明細は、明細表で"#{col_name}"が"#{row[col_name]}"であること}
    end
  end
end

Then /商品ごとに集計した表が以下と等しいこと$/ do |table|
  table.hashes.each do |row|
    row.keys.each do |col_name|
      within(".item_#{Item.find_by(name: row['商品名']).id}") do
        td_text = find(to_class_in_aggregate_table(col_name)).text
        expect(td_text).to eq row[col_name]
      end
    end
  end
end

Then /^"(.*?)"の商品内訳の表が以下になること$/ do |user_name, table|
  tr_class_of_user = ".user_#{User.find_by(name: user_name).id}"
  within(tr_class_of_user) do
    all('.inner_table').zip(table.hashes).each do |detail, row|
      expect(detail.find('.name').text)    .to eq row['品名']
      expect(detail.find('.quantity').text).to eq row['数量']
    end
  end
end

Then /^"(.*?)"の商品内訳は表にないこと$/ do |user_name|
  tr_class_of_user = ".user_#{User.find_by(name: user_name).id}"

  expect(page).not_to have_css(tr_class_of_user)
end
