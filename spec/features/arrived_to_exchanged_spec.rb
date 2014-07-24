feature '引換用ページ' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.update_attributes(
      state: 'arrived',
      order_details: [
        build(:order_detail, item: items(:herb_tea)),
        build(:order_detail, item: items(:red_tea))
      ]
    )

    login_as 'Alice'

    visit '/orders/arrived'
  end

  scenario '引換してない商品があるなら、商品名とユーザー名が表示されている' do
    expect(page).to have_content 'herb_tea'
    expect(page).to have_content 'red_tea'
    expect(page).to have_content 'Alice'
  end

  scenario '何もチェックを入れないとき、ボタンを押しても移動しない' do
    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/arrived'
  end

  scenario '注文のチェックを入れて登録ボタンを押す場合、引換済みページに移動して成功メッセージがでる' do
    check "user_#{alice.id}"

    click_button '引換の完了をシステムに登録'

    expect(page.current_path).to eq '/orders/exchanged'
    expect(page).to have_content '引換したことを登録しました。'
    expect(page).to have_content 'Alice'
  end
end