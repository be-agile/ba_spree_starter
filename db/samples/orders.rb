# spree_sample-5.3.6/db/samples/orders.rb を差し替えたもの。
#
# 本家からの変更点:
#   1. 商品名 'Denim Shirt' / 'Checked Shirt' を日本語のサンプル商品名に変更
#      (variants.csv を日本語化したため、英語名では見つからず落ちる)
#   2. 通貨を USD から JPY に変更 (ストアの default_currency に合わせる)
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::Sample.load_sample('addresses')
Spree::Sample.load_sample('products')

CURRENCY = 'JPY'.freeze

store = Spree::Store.default
product_1 = Spree::Product.find_by!(name: 'デニムシャツ')
product_2 = Spree::Product.find_by!(name: 'チェックシャツ')

orders = []
orders << store.orders.where(
  store: store,
  number: 'R123456789',
  email: 'spree@example.com',
  currency: CURRENCY
).first_or_create! do |order|
  order.item_total = product_1.default_variant.amount_in(order.currency)
  order.adjustment_total = product_1.default_variant.amount_in(order.currency)
  order.total = product_1.default_variant.amount_in(order.currency) * 2
end

orders << store.orders.where(
  number: 'R987654321',
  email: 'spree@example.com',
  currency: CURRENCY
).first_or_create! do |order|
  order.item_total = product_2.default_variant.amount_in(order.currency)
  order.adjustment_total = product_2.default_variant.amount_in(order.currency)
  order.total = product_2.default_variant.amount_in(order.currency) * 2
  order.shipping_address = Spree::Address.first
  order.billing_address = Spree::Address.last
end

unless orders[0].line_items.any?
  orders[0].line_items.new(
    variant: product_1.default_variant,
    quantity: 1,
    price: product_1.default_variant.amount_in(orders[0].currency)
  ).save!
end

unless orders[1].line_items.any?
  orders[1].line_items.new(
    variant: product_2.default_variant,
    quantity: 1,
    price: product_2.default_variant.amount_in(orders[1].currency)
  ).save!
end

orders.each(&:create_proposed_shipments)

Spree::Order.where(id: orders.map(&:id)).update_all(state: :complete, completed_at: Time.current - 1.day)
