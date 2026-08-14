# spree_sample-5.3.6/db/samples/payment_methods.rb を日本の決済手段に差し替えたもの。
#
# 本家は Spree::Gateway::Bogus (ダミーのクレジットカード) と
# Spree::PaymentMethod::Check (小切手) を作るが、日本では使わないため、
# ba_spree が提供する銀行振込・代金引換に置き換える。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
bank_transfer = Spree::PaymentMethod::BankTransfer.where(
  name: '銀行振込',
  description: 'ご注文後、指定の口座にお振込ください。',
  active: true
).first_or_initialize
bank_transfer.display_on = 'both'
bank_transfer.auto_capture = false
bank_transfer.stores = Spree::Store.all
bank_transfer.save!

cash_on_delivery = Spree::PaymentMethod::CashOnDelivery.where(
  name: '代金引換',
  description: '商品到着時に配達員へ代金をお支払いください。',
  active: true
).first_or_initialize
cash_on_delivery.display_on = 'both'
cash_on_delivery.auto_capture = true
cash_on_delivery.stores = Spree::Store.all
cash_on_delivery.save!
