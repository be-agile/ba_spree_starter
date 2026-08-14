# This migration comes from spree_bank_transfer (originally 20140612131656)
class AddColAdditionalDetailsToBanks < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_banks, :additional_details, :text
  end
end
