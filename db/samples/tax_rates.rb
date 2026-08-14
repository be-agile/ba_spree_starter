# spree_sample-5.3.6/db/samples/tax_rates.rb を差し替えたもの。
#
# 本家は 'California' 税率と 'Clothing' 税区分を前提にしているが、
# 消費税 (10% / 8% / 非課税) は BaSpree::SetupService が db/seeds.rb で
# 作成済みなので、ここではサンプル商品用の税区分をゾーン「日本」に紐づけるだけ。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::Sample.load_sample('tax_categories')
Spree::Sample.load_sample('zones')

japan_zone = Spree::Zone.find_by!(name: '日本')
clothing = Spree::TaxCategory.find_by!(name: '衣料品')

Spree::TaxRate.where(
  name: '消費税(衣料品)',
  zone: japan_zone,
  amount: 0.1,
  tax_category: clothing
).first_or_create! do |tax_rate|
  tax_rate.included_in_price = true
  tax_rate.show_rate_in_label = true
  tax_rate.calculator = Spree::Calculator::DefaultTax.create!
end
