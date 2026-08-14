# This migration comes from spree_address_format_i18n (originally 20241231080436)
class AddKanaColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column 'spree_addresses', :firstname_kana, :string unless column_exists?('spree_addresses', :firstname_kana)
    add_column 'spree_addresses', :lastname_kana, :string unless column_exists?('spree_addresses', :lastname_kana)
  end
end
