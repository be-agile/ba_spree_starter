# This migration comes from spree_limit_order_quantity (originally 20250505025922)
class AddOrderQuantityLimitsToSpreeVariants < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_variants, :min_order_quantity, :integer, null: true
    add_column :spree_variants, :max_order_quantity, :integer, null: true
  end
end
