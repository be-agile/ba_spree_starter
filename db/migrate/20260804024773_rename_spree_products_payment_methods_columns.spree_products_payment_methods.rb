# This migration comes from spree_products_payment_methods (originally 20250625214200)
class RenameSpreeProductsPaymentMethodsColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :spree_products_payment_methods, :spree_product_id, :product_id if column_exists?(:spree_products_payment_methods, :spree_product_id)
    rename_column :spree_products_payment_methods, :spree_payment_method_id, :payment_method_id if column_exists?(:spree_products_payment_methods, :spree_payment_method_id)
    remove_index :spree_products_payment_methods, name: 'index_products_payment_methods' if index_exists?(:spree_products_payment_methods, [:spree_product_id, :spree_payment_method_id], name: 'index_products_payment_methods')
    add_index :spree_products_payment_methods, [:product_id, :payment_method_id], name: 'index_products_payment_methods' unless index_exists?(:spree_products_payment_methods, [:product_id, :payment_method_id], name: 'index_products_payment_methods')
  end
end
