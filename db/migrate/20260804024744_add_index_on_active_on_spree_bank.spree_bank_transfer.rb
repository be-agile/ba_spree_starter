# This migration comes from spree_bank_transfer (originally 20130717125312)
class AddIndexOnActiveOnSpreeBank < SpreeExtension::Migration[4.2]
  def change
    add_index :spree_banks, :active
  end
end
