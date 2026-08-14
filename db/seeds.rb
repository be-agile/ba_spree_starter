# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Spree の標準 seed (国・州・ロール・配送カテゴリ等) を流す
Spree::Core::Engine.load_seed if defined?(Spree::Core)

# ba_spree でストアを日本仕様にする。
# 国=日本 / 47都道府県 / ゾーン「日本」 / 消費税 10%・8%・非課税 /
# 配送料(定額) / 通貨 JPY / ロケール ja を設定する。
# ストア名・URL・メールアドレスには触れないので、それらはこの下で設定する。
# @see https://github.com/be-agile/giga-repeat/issues/1317
if defined?(BaSpree::SetupService)
  store = Spree::Store.default
  BaSpree::SetupService.setup(store: store, load_seed: false)

  # サンプルストアの初期値。実際に運用する際は管理画面から変更する
  store.update!(
    name: "ba_spree サンプルストア",
    code: "ba-spree-sample",
    mail_from_address: "noreply@example.com",
    customer_support_email: "support@example.com",
    new_order_notifications_email: "orders@example.com"
  )
end
