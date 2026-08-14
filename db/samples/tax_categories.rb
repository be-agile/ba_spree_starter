# spree_sample の 'Clothing' を日本語化したもの。
# @see https://github.com/be-agile/giga-repeat/issues/1317
Spree::TaxCategory.where(name: '衣料品').first_or_create!
