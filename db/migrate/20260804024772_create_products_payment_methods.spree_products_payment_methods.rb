# This migration comes from spree_products_payment_methods (originally 20250219074745)
class CreateProductsPaymentMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :spree_products_payment_methods do |t|
      t.references :spree_product
      t.references :spree_payment_method
      t.timestamps
    end

    add_index :spree_products_payment_methods, [ :spree_product_id, :spree_payment_method_id ],
      name: 'index_products_payment_methods'
  end
end
