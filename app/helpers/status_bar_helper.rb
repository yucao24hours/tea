module StatusBarHelper
  def user_cart_position(order)
    case order.status_with_period
    when 'undefined_period'
      0
    when 'can_add_detail'
      1
    when 'wait_ordered'
      2
    when 'nothing_added'
      return 'not_a_number. cart is in second line'
    when 'ordered'
      3
    when 'arrived'
      4
    when 'exchanged'
      5
    else
      raise "bag in #{__method__}"
    end
  end

  def user_position_explain(order)
    cart_position_names = order.cart_position_names(nothing_added: true)
    explain = case order.status_with_period
    when 'undefined_period'
      [cart_position_names[0],
      '管理者が注文期間を設定して、注文の募集を始めるのを待っています。']
    when 'can_add_detail'
      [cart_position_names[1],
    '注文ができます。<br>フォームから欲しいお茶の品名と個数を選んで追加・削除してください。']
    when 'wait_ordered'
      [cart_position_names[2],
      '管理者がネスレに発注する（ネスレから購入する）のを待っています。']
    when 'nothing_added'
      [cart_position_names[6],
      '注文をせずに注文期間が終了しました。<br>管理者が次回の注文を募集するまでお待ちください。']
    when 'ordered'
      [cart_position_names[3],
      '注文が発注されました。お茶が支社に届くのを待っています。']
    when 'arrived'
      [cart_position_names[4],
      'お茶が支社に届きました。<br>管理者にお金を渡してお茶を受け取れます。']
    when 'exchanged'
      [cart_position_names[5],
      '引換が完了しました。<br>管理者が次回の注文を募集するまでお待ちください。']
    else
      raise "bag in #{__method__}"
    end
    {title: explain[0], paragraph: explain[1]}
  end

  def user_position_instruction(order)
    explain = case order.status_with_period
    when 'undefined_period'
      <<-"EOS".strip_heredoc
      管理者が注文期間を設定して、注文の募集を始めるのを待っています。
      EOS
    when 'can_add_detail'
      <<-"EOS".strip_heredoc
      注文ができます。<br>
      フォームから欲しいお茶の品名と個数を選んで追加・削除してください。
      EOS
    when 'wait_ordered'
      <<-"EOS".strip_heredoc
      近日中に管理者がネスレに発注します。<br>
      発注とは、管理者がユーザーの注文しているお茶を#{about_page_link(link_text: 'ネスレ')}から購入することを指します。
      EOS
    when 'nothing_added'
      <<-"EOS".strip_heredoc
      注文をせずに注文期間が終了しました。<br>
      管理者が次回の注文を募集するまでお待ちください。
      EOS
    when 'ordered'
      <<-"EOS".strip_heredoc
      お茶が発注されました。支社に届くのを待っています。
      EOS
    when 'arrived'
      <<-"EOS".strip_heredoc
      注文したお茶が支社に届きました。<br>
      管理者にお金を渡してお茶を受け取れます。
      EOS
    when 'exchanged'
      <<-"EOS".strip_heredoc
      引換が完了しました。<br>
      管理者が次回の注文を募集するまでお待ちください。
      EOS
    else
      raise "bag in #{__method__}"
    end
  end
end
