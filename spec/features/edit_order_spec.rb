feature '既存の注文を修正する'do
  let!(:alice) { create(:user, name: 'Alice') }
  let!(:herb_tea) { create(:item, name: 'herb_tea', price: 100) }
  let(:herb_tea_detail_of_alice) { OrderDetail.find_by_item_id!(Item.find_by_name! 'herb_tea') } #FIXME

  background do
    red_tea = create(:item, name: 'red_tea', price: 100) #対称性に欠くけどletを増やしたくないので

    alice.order.update_attributes(
      order_details: [
        build(:order_detail, item: herb_tea, quantity: 1),
        build(:order_detail, item: red_tea, quantity: 1)
      ]
    )

    login_as 'Alice'
  end

  scenario '既存の注文明細がある場合、注文画面にいくと明細と合計金額が見れる' do
    expect(page).to exist_in_table 'herb_tea'
    expect(page.find(:css, '#edit_order_sum_yen').text).to eq '200円' #これのためfixturesを使わない
  end

  context 'さらに別のお茶を注文する場合' do
    background do
      create :item, name: 'green_tea', price: 100
      click_link '注文画面'
    end

    scenario '商品と個数を選んで「注文する」を押すと、表に明細が追加されて、メッセージも出る' do
      choose_item_and_quantity 'green_tea', 1
      click_button '注文する'

      expect(page).to exist_in_table 'green_tea'
      expect(page).to have_content 'green_teaを追加しました。'
    end

    scenario '品名だけを選んだ場合、注文はできない' do
      choose_item_and_quantity 'green_tea', ''
      click_button '注文する'

      expect(page).not_to exist_in_table 'green_tea'
      expect(page).to have_content '商品名と数量を両方指定して注文してください'
    end

    scenario '数量だけを選んだ場合、注文はできない' do
      choose_item_and_quantity '', 1
      click_button '注文する'

      expect(page).not_to exist_in_table 'green_tea'
      expect(page).to have_content '商品名と数量を両方指定して注文してください'
    end
  end

  #TODO: 追加済みのお茶は、選択肢を出さなくしたほうが良い
  scenario '明細表にあるお茶をさらに追加しようとすると、エラーになる' do
    expect(page).to exist_in_table 'herb_tea'

    choose_item_and_quantity 'herb_tea', 1

    click_button '注文する'

    expect(page).to have_content 'その商品は既に注文しています。'
  end

  scenario '明細の横の「削除する」リンクを押すと、表から明細が削除されて、通知がある' do
    find("#destroy_detail#{herb_tea_detail_of_alice.id}").click

    expect(page).not_to exist_in_table 'herb_tea'
    expect(page).to have_content 'herb_teaの注文を削除しました。'
  end

  context 'Bobとしてログインした場合' do
    before  do
      create_user_and_login_as 'Bob'
    end

    scenario 'Bobが注文を追加した場合も、注文済み商品の合計金額が見れる' do
      choose_item_and_quantity 'red_tea', 3
      click_button '注文する'

      choose_item_and_quantity 'herb_tea', 1
      click_button '注文する'

      expect(page.find(:css, '#edit_order_sum_yen').text).to eq '400円'
    end
  end
end