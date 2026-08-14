# This migration comes from spree_np_atobarai (originally 20250401033922)
class AddColumnInvoiceSendingToPayment < ActiveRecord::Migration[8.0]
  def change
    add_column :spree_payments, :invoice_sending, :string, null: true
  end
end
