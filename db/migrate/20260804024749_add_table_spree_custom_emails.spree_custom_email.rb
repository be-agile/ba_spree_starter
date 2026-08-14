# This migration comes from spree_custom_email (originally 20250306091041)
class AddTableSpreeCustomEmails < ActiveRecord::Migration[8.0]
  def change
    create_table :spree_custom_emails do |t|
      t.references :store, foreign_key: { to_table: :spree_stores }
      t.integer :mail_type, null: false
      t.string :subject
      t.text :header
      t.text :footer
      t.timestamps

      t.index [:store_id, :mail_type], unique: true
    end

    reversible do |dir|
      dir.up do
        Spree::CustomEmail.reset_column_information
        stores = Spree::Store.pluck(:id)

        stores.each do |store_id|
          Spree::CustomEmail.create!(store_id: store_id, mail_type: 0)
          Spree::CustomEmail.create!(store_id: store_id, mail_type: 1)
          Spree::CustomEmail.create!(store_id: store_id, mail_type: 2)
          Spree::CustomEmail.create!(store_id: store_id, mail_type: 3)
        end
      end

      dir.down do
        Spree::CustomEmail.delete_all
      end
    end
  end
end
