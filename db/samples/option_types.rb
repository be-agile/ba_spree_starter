# spree_sample-5.3.6/db/samples/option_types.rb の presentation を日本語化したもの。
# name(キー)は variants.rb 等が参照するため英語のまま。
# @see https://github.com/be-agile/giga-repeat/issues/1317
{ 'color' => '色', 'size' => 'サイズ' }.each do |name, presentation|
  Spree::OptionType.find_or_create_by!(name: name) do |option_type|
    option_type.presentation = presentation
  end
end
