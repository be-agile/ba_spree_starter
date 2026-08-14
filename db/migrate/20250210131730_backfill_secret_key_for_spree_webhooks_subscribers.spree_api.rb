# This migration comes from spree_api (originally 20230116204600)
#
# Spree 5.3.6 では Spree::Webhooks::Subscriber が削除され、webhook は
# Spree::WebhookEndpoint / Spree::WebhookDelivery に置き換わっている。
# 上流の migration はモデルクラスを直接参照しているため、新規インストールでは
# NameError で全 migration が停止する。migration 内で完結する無名クラスに置き換える。
# @see https://github.com/be-agile/giga-repeat/issues/1317
class BackfillSecretKeyForSpreeWebhooksSubscribers < ActiveRecord::Migration[6.1]
  class Subscriber < ActiveRecord::Base
    self.table_name = 'spree_webhooks_subscribers'
  end

  def up
    return unless table_exists?(:spree_webhooks_subscribers)

    Subscriber.where(secret_key: nil).find_each do |subscriber|
      subscriber.update_column(:secret_key, SecureRandom.hex(24))
    end
  end

  def down
    # 既存レコードへの backfill のため、戻す処理は持たない
  end
end
