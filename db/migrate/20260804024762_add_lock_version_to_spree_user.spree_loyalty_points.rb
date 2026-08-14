# This migration comes from spree_loyalty_points (originally 20140207055836)
class AddLockVersionToSpreeUser < ActiveRecord::Migration[8.0]
  def change
    users_table_name = Spree.user_class.present? ? Spree.user_class.table_name : :spree_users
    add_column users_table_name, :lock_version, :integer, default: 0, null: false unless column_exists?(users_table_name, :lock_version)
  end
end
