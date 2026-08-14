# spree_sample-5.3.6/db/samples/variants.rb を日本語サンプル用に差し替えたもの。
#
# 本家からの変更点:
#   1. product_name.titleize をやめる (products.rb と同じ理由)
#   2. SKU の組み立てから product.name.parameterize を外す
#      parameterize は非ASCIIを除去するため "デニムシャツ".parameterize は ""
#      となり、全商品のSKUが "-XS-BLUE" のように衝突してしまう。
#      商品IDを使って一意にする
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
require 'csv'

Spree::Sample.load_sample('tax_categories')
Spree::Sample.load_sample('option_types')
Spree::Sample.load_sample('products')

color_option_type = Spree::OptionType.find_by!(name: 'color')
size_option_type = Spree::OptionType.find_by!(name: 'size')

VARIANTS = CSV.read(File.join(__dir__, 'variants.csv'))

color_option_values = color_option_type.option_values.to_a
size_option_values = size_option_type.option_values.to_a

clothing_tax_category = Spree::TaxCategory.find_or_create_by!(name: '衣料品')

VARIANTS.each do |(_parent_name, _taxon_name, product_name, color_name)|
  # 4列目は option_value の name(英語のキー)。表示名は presentation 側で日本語化している
  color = color_option_values.find { |c| c.name == color_name }

  product = Spree::Product.find_by!(name: product_name)

  size_option_values.each do |size|
    sku = "#{product.id}-#{size.name.parameterize}-#{color.name.parameterize}".upcase

    variant = product.variants.find_or_initialize_by(sku: sku) do |variant|
      variant.cost_price = product.price
      variant.option_values = [color, size]
      variant.sku = sku
      variant.tax_category = clothing_tax_category
      variant.track_inventory = true
    end
    variant.save!
  end
end
