# spree_sample-5.3.6/db/samples/option_values.rb の presentation を日本語化したもの。
#
# name(キー)は英語のまま残す。variants.csv の4列目および variants.rb が
# option_value.name で色を引いているため、ここを日本語にすると解決できなくなる。
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::Sample.load_sample('option_types')

color_option_type = Spree::OptionType.find_by!(name: 'color')
size_option_type = Spree::OptionType.find_by!(name: 'size')

colors = {
  white: 'ホワイト',
  purple: 'パープル',
  red: 'レッド',
  black: 'ブラック',
  brown: 'ブラウン',
  green: 'グリーン',
  grey: 'グレー',
  orange: 'オレンジ',
  burgundy: 'バーガンディ',
  beige: 'ベージュ',
  mint: 'ミント',
  blue: 'ブルー',
  'dark-blue': 'ダークブルー',
  khaki: 'カーキ',
  yellow: 'イエロー',
  'light-blue': 'ライトブルー',
  pink: 'ピンク',
  lila: 'ライラック',
  ecru: 'エクリュ'
}

sizes = { xs: 'XS', s: 'S', m: 'M', l: 'L', xl: 'XL' }

colors.each do |color|
  color_option_type.option_values.find_or_create_by!(name: color.first) do |option_value|
    option_value.presentation = color.last
  end
end

sizes.each do |size|
  size_option_type.option_values.find_or_create_by!(name: size.first) do |option_value|
    option_value.presentation = size.last
  end
end
