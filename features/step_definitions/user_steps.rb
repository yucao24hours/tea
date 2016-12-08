Given /^ユーザー"(.*?)"がユーザー登録している$/ do |user_name|
  create :user, name: user_name
end

Given /^ユーザー"(.*?)"がログインしている$/ do |user_name|
  visit "/login"
  fill_in "ユーザー名", with: user_name
  click_button "ログイン"
end

Given /^ユーザー"(.*?)"が登録してログインしている$/ do |user_name|
  create :user, name: user_name
  step %Q|ユーザー"#{user_name}"がログインしている|
end

When /^ユーザー"(.*?)"がログアウトする$/ do |user_name|
  login_user_name = get_user_name_from_header!
  if login_user_name == User.find_by(name: user_name).name
    click_link 'ログアウト'
  else
    raise "before logout, #{user_name} must be logged in"
  end
end
