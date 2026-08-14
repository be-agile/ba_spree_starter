# spree_sample-5.3.6/db/samples/products.rb を日本語サンプル用に差し替えたもの。
#
# 本家からの変更点:
#   1. product_name.titleize をやめる
#      "ベーシックTシャツ".titleize は "ベーシックtシャツ" となり、
#      大文字の T が小文字に落ちて商品名が壊れるため
#   2. 価格をドル建て (rand(10...100) + 0.99) から円建てに変更
#   3. 商品説明の FFaker::Lorem.paragraph (英語) を日本語のダミー文に変更
#
# @see https://github.com/be-agile/giga-repeat/issues/1317
require 'csv'

Spree::Sample.load_sample('tax_categories')
Spree::Sample.load_sample('option_types')
Spree::Sample.load_sample('taxons')

default_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: I18n.t('spree.seed.shipping.categories.default'))
clothing_tax_category = Spree::TaxCategory.find_or_create_by!(name: '衣料品')

color_option_type = Spree::OptionType.find_by!(name: 'color')
size_option_type = Spree::OptionType.find_by!(name: 'size')

PRODUCTS = CSV.read(File.join(__dir__, 'variants.csv'))

# 日本語のダミー説明文。FFaker は日本語の文章を持たないため固定文から組み立てる
PRODUCT_DESCRIPTION_PARTS = [
  '日常使いにちょうどよい定番アイテムです。',
  '肌ざわりのよい素材を使い、長時間着ても疲れにくい仕上がりです。',
  'シンプルなデザインなので、合わせるアイテムを選びません。',
  'オンオフどちらの場面でも活躍します。',
  '洗濯機で丸洗いでき、お手入れも簡単です。',
  'ゆとりのあるシルエットで、体型を選ばずお召しいただけます。'
].freeze

taxons = Spree::Taxon.includes(:children).all

PRODUCTS.each do |(parent_name, taxon_name, product_name, _color_name)|
  parent = taxons.find { |taxon| taxon.name == parent_name }
  taxon = parent.children.find { |child| child.name == taxon_name }

  sleep(0.1) # to avoid DB lock

  product = Spree::Product.find_or_initialize_by(name: product_name) do |product|
    # 円建てのため端数は持たせない
    product.price = rand(20..150) * 100
    product.description = PRODUCT_DESCRIPTION_PARTS.sample(3).join
    product.available_on = Time.zone.now
    product.status = 'active'
    product.option_types = [color_option_type, size_option_type]
    product.shipping_category = default_shipping_category
    product.tax_category = clothing_tax_category
    product.taxons = [taxon]
  end
  product.save!
end

store_ids = Spree::Store.ids
product_ids = Spree::Product.ids

store_ids.each do |store_id|
  if ActiveRecord::Base.connection.adapter_name == 'Mysql2'
    Spree::StoreProduct.upsert_all(
      product_ids.map { |product_id| { store_id: store_id, product_id: product_id } }
    )
  else
    Spree::StoreProduct.upsert_all(
      product_ids.map { |product_id| { store_id: store_id, product_id: product_id } },
      unique_by: [:store_id, :product_id]
    )
  end
end

# ダウンロード販売のサンプル
digital_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: I18n.t('spree.seed.shipping.categories.digital'))

digital_product = Spree::Product.find_or_initialize_by(name: 'デジタルダウンロード') do |product|
  product.price = 3_000
  product.description = 'ご購入後すぐにダウンロードいただけるデジタル商品です。'
  product.available_on = Time.zone.now
  product.status = 'active'
  product.shipping_category = digital_shipping_category
  product.stores = Spree::Store.all
  product.track_inventory = false
end
digital_product.save!
