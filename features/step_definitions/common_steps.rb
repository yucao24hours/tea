Given "デバッグ" do
  binding.pry
end

Given "スクリーンショット" do
  save_and_open_page
end

When /^"(.*?)"ボタンを押す$/ do |button_text|
  click_button button_text
end

When /^"(.*?)"のリンクをクリックする$/ do |link_text|
  click_link link_text
end

When /^ページをリロードする$/ do
  visit page.current_path
end

Then /^"(.*?)"と表示されていること$/ do |content|
  expect(page).to have_content content
end
