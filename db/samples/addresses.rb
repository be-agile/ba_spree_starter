# spree_sample-5.3.6/db/samples/addresses.rb を日本の住所に差し替えたもの。
#
# 本家は米国(ニューヨーク州)の住所を作るが、BaSpree::SetupService が
# 国=日本・47都道府県を用意するので、それに合わせる。
# FFaker は日本語の住所を持たないため、固定のサンプル住所を使う。
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
japan = Spree::Country.find_by!(iso: 'JP')
tokyo = Spree::State.find_by!(name: '東京都', country: japan)

SAMPLE_ADDRESSES = [
  {
    firstname: '太郎', lastname: '山田',
    address1: '千代田区丸の内1-1-1', address2: 'サンプルビル10F',
    city: '東京都', zipcode: '100-0005', phone: '03-1234-5678'
  },
  {
    firstname: '花子', lastname: '鈴木',
    address1: '渋谷区神南1-2-3', address2: 'サンプルマンション201',
    city: '東京都', zipcode: '150-0041', phone: '03-8765-4321'
  }
].freeze

SAMPLE_ADDRESSES.each do |attributes|
  Spree::Address.create!(attributes.merge(state: tokyo, country: japan))
end
