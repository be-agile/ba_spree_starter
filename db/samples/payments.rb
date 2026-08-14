# spree_sample-5.3.6/db/samples/payments.rb を差し替えたもの。
#
# 本家は Spree::Gateway::Bogus のクレジットカード決済でサンプル支払いを作るが、
# payment_methods.rb を銀行振込・代金引換に差し替えたため、
# クレジットカード関連の処理を外し、銀行振込の支払いを作る。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::Sample.load_sample('payment_methods')

payment_method = Spree::PaymentMethod.find_by!(name: '銀行振込')

Spree::Order.all.each do |order|
  order.update_with_updater!
  payment = order.payments.where(
    amount: BigDecimal(order.total, 4),
    payment_method: payment_method
  ).first_or_create!

  payment.update_columns(state: 'pending', response_code: '12345')
end
