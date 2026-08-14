# spree_sample-5.3.6/db/samples/zones.rb を差し替えたもの。
#
# 本家は米国カリフォルニア州のゾーンを作るが、日本向けストアでは不要。
# ゾーン「日本」は BaSpree::SetupService が db/seeds.rb で作成済みなので、
# ここでは存在確認だけ行う。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
unless Spree::Zone.exists?(name: '日本')
  puts 'ゾーン「日本」が見つかりません。先に `rails db:seed` を実行してください。'
  exit(1)
end
