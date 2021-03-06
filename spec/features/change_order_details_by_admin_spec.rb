feature '管理者ページからユーザーの注文を変更する' do
  fixtures :items

  let!(:alice) { create(:user, name: 'Alice') }

  background do
    alice.order.update_attributes!(
      order_details: [build(:order_detail, item: items(:herb_tea))]
    )

    login_as 'Alice'

    visit 'admin/users'
  end

  context '注文期間中に編集ページに来た時' do
    background do
      within ".#{ActionView::RecordIdentifier.dom_id(alice)}" do
        click_link '編集'
      end
    end

    scenario '削除リンクを押すと、明細を削除できる' do
      click_link '注文変更ページ'

      detail = alice.order.order_details.where(item_id: items(:herb_tea)).take

      within ".#{ActionView::RecordIdentifier.dom_id(detail)}" do
        click_link '削除'
      end

      expect(page).not_to exist_in_table "#{items(:herb_tea).name}"
    end

    scenario '注文変更ページに飛んでお茶を追加すると、明細表に表示される。' do
      click_link '注文変更ページ'

      choose_item_and_quantity items(:ice_mint), 1
      click_button '追加する'

      expect(page).to exist_in_table "#{items(:ice_mint).name}"
    end

    scenario '注文変更ページに飛んでお茶の名前や数量を不適切に指定した場合、エラーがでる。' do
      click_link '注文変更ページ'

      choose_item_and_quantity '', ''
      click_button '追加する'

      expect(page).to have_content 'お茶の名前を選択してください。'
      expect(page).to have_content 'お茶の数量を選択してください。'
    end
  end

  context '注文期間外に編集ページに来た時' do
    background do
      wait_untill_period_become_out_of_date

      within ".#{ActionView::RecordIdentifier.dom_id(alice)}" do
        click_link '編集'
      end
    end

    scenario '注文変更ページへのリンクがない' do
      expect(page).not_to have_link '注文変更ページ'
    end

    scenario 'URL直打ち、ブックマークからも、注文の変更はできない' do
      visit "/admin/users/#{alice.id}/order_details"

      Capybara.exact = true
      expect(page).not_to have_link '削除'
      expect(page).not_to have_button '追加する'
      Capybara.exact = false
    end
  end
  context '注文期間未設定の時編集ページに来た時' do
    background do
      alice.order.order_details.each do |detail|
        OrderDetail.destroy detail
      end

      Period.set_undefined_times!

      within ".#{ActionView::RecordIdentifier.dom_id(alice)}" do
        click_link '編集'
      end
    end

    scenario '注文変更ページへのリンクがない' do
      expect(page).not_to have_link '注文変更ページ'
    end

    scenario 'URL直打ち、ブックマークからも、注文の変更はできない' do
      visit "/admin/users/#{alice.id}/order_details"

      Capybara.exact = true
      expect(page).not_to have_link '削除'
      expect(page).not_to have_button '追加する'
      Capybara.exact = false
    end
  end
end
