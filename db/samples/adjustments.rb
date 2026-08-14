# spree_sample-5.3.6/db/samples/adjustments.rb を差し替えたもの。
# 参照する税率を 'California' から日本の消費税に変更しただけで、構造は本家と同じ。
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::Sample.load_sample('orders')

first_order = Spree::Order.find_by!(number: 'R123456789')
last_order = Spree::Order.find_by!(number: 'R987654321')

tax_rate = Spree::TaxRate.find_by!(name: '消費税(衣料品)')

[first_order, last_order].each do |order|
  order.adjustments.where(
    source: tax_rate,
    order: order,
    label: '消費税',
    state: 'open',
    mandatory: true
  ).first_or_create! do |adj|
    adj.amount = 0
  end
end
