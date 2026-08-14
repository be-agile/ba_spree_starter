# spree_sample-5.3.6/db/samples/shipping_methods.rb を日本向けに差し替えたもの。
#
# 本家は 'North America' / 'EU_VAT' ゾーンを前提にしているが、
# BaSpree::SetupService がこれら海外向けゾーンを削除するため、そのままでは
# RecordNotFound で落ちる。ゾーン「日本」を前提に組み直す。
#
# なお BaSpree::SetupService が「配送料」(定額500円) を既に作っているので、
# ここではサンプルとして選択肢を増やす分だけを追加する。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
begin
  japan_zone = Spree::Zone.find_by!(name: '日本')
rescue ActiveRecord::RecordNotFound
  puts 'ゾーン「日本」が見つかりません。先に `rake db:seed` を実行してください。'
  puts 'db/seeds.rb が BaSpree::SetupService でゾーン・消費税・配送料を作成します。'
  exit
end

shipping_category = Spree::ShippingCategory.find_or_create_by!(name: I18n.t('spree.seed.shipping.categories.default'))

# 金額は税込の想定。BaSpree::SetupService の「配送料」(500円) と揃えた価格帯にする
shipping_methods = {
  '宅配便(通常)' => 500,
  '宅配便(お届け日指定)' => 800,
  'ネコポス(ポスト投函)' => 300
}

shipping_methods.each do |name, amount|
  shipping_method = Spree::ShippingMethod.where(name: name).first_or_create! do |method|
    method.calculator = Spree::Calculator::Shipping::FlatRate.create!
    method.zones = [japan_zone]
    method.display_on = 'both'
    method.shipping_categories = [shipping_category]
  end

  shipping_method.calculator.preferences = { amount: amount, currency: 'JPY' }
  shipping_method.calculator.save!
  shipping_method.save!
end
