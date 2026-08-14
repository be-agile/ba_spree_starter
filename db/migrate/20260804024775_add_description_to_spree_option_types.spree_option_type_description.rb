# This migration comes from spree_option_type_description (originally 20250509025036)
class AddDescriptionToSpreeOptionTypes < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_option_types, :description, :text
  end
end
