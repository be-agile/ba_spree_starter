# ba_spree Starter

[English](README.md) | 日本語

**日本向けの設定を済ませた、すぐ動く Spree ストアです。**

[ba_spree](https://github.com/be-agile/ba_spree) のスターターキットです。
ba_spree は、日本で EC を運用するのに必要な部分 — 住所の入力順、47都道府県、
消費税の内税表示、銀行振込・代金引換 — を最初から用意した Spree Commerce の拡張群です。

clone してコマンドをいくつか実行すれば、サンプル商品の入った日本語のショップが立ち上がります。

対応 Spree バージョン: **5.3.6** · Ruby **3.3.7** · MySQL

---

## 動作環境

- Ruby 3.3.7
- MySQL
- Redis (Sidekiq のバックグラウンドジョブで使用)
- Node.js と Yarn (CSS のビルドに使用)
- libvips (画像処理。[トラブルシューティング](#トラブルシューティング)参照)

## インストール

```bash
git clone https://github.com/be-agile/ba_spree_starter.git
cd ba_spree_starter

bundle install

bin/rails db:create db:migrate
bin/rails db:seed              # 国・都道府県・消費税・配送料・通貨(JPY)・ロケール(ja)
bin/rails spree_sample:load    # 日本語のサンプル商品・注文

bin/dev
```

http://localhost:3000 を開いてください。

### 最初につまずきやすい3点

**1. `rails server` ではなく `bin/dev` を使ってください。**

ビルド済み CSS はリポジトリに含めていないため、clone 直後は存在しません。
`bin/dev` はサーバーと一緒に Tailwind のビルドを走らせます。
`rails server` を単体で実行すると、全ページが次のエラーで 500 になります。

```
Propshaft::MissingAssetError: The asset 'tailwind.css' was not found in the load path.
```

サーバーだけを起動したい場合は、先に CSS をビルドしてください。

```bash
bin/rails tailwindcss:build
bin/rails spree:admin:tailwindcss:build
bin/rails server
```

**2. `db:seed` と `spree_sample:load` は別のコマンドです。**

`db:seed` はストアを日本仕様にするだけで、商品は投入しません。
サンプル商品は `spree_sample:load` の側に入っています。
実行し忘れると、設定は正しいのに商品が1件もないショップになります
(壊れているように見えますが、正常です)。

**3. `BA_SPREE_PATH` は任意です。**

ba_spree の gem 群は RubyGems に公開済みなので、`bundle install` だけで入ります。
`BA_SPREE_PATH` は、公開版ではなく手元の checkout で engine を開発したい場合にだけ指定します。

```bash
BA_SPREE_PATH=/path/to/giga-repeat/engines bundle install
```

指定すると、`ba_spree.gemspec` の依存をそのディレクトリ内の gemspec で辿り、見つかった engine を
RubyGems ではなくそのディレクトリから読み込みます。engine の一覧を `Gemfile` に書き足す必要はありません。

## 何が入るか

`db:seed` がストアを日本仕様にします。

- 国 = 日本、47都道府県
- ゾーン「日本」
- 消費税 10% / 8%(軽減税率)/ 非課税
- 配送料(定額)
- 通貨 JPY、ロケール ja

`spree_sample:load` が日本語のデモカタログを追加します。

- 日本語名の商品 117件(デニムシャツ、チェックシャツ …)
- バリエーション 1,082件(色・サイズも日本語)
- タクソン 30件(2026年 夏、サマーセール、ジャケット・コート …)
- 価格は円単位(本家の `.99` ドル表記ではありません)
- 銀行振込・代金引換の決済手段
- 宅配便・ネコポスなどの配送方法

日本の住所フォーマット、郵便番号による住所自動入力、ポイント、NP後払いといった
拡張機能そのものについては [ba_spree の README](https://github.com/be-agile/ba_spree)
を参照してください。

## 本家 Spree starter との違い

このリポジトリは [spree/spree_starter](https://github.com/spree/spree_starter) の fork です。
変更点は次のとおりです。

| | 本家 | このスターター |
|---|---|---|
| データベース | PostgreSQL | MySQL |
| 決済 | Stripe、PayPal | 銀行振込、代金引換(ba_spree の日本向け決済) |
| Klaviyo 連携 | あり | 削除 |
| サンプルデータ | 英語 | 日本語の商品・タクソン・住所 |
| ロケール | 英語 | 日本語 (`ja`) |

認証の Devise、バックグラウンドジョブの Sidekiq、キャッシュの Redis など、
それ以外は本家のままです。

## テストの実行

```bash
bundle exec rspec
```

## トラブルシューティング

### `BA_SPREE_PATH` を指定すると `bundle install` が `spree_*` gem を解決できない

エラーに出ている gem が、`BA_SPREE_PATH` の直下に `<gem名>/<gem名>.gemspec` として存在するか確認してください。
見つからない engine は RubyGems から取得しようとするため、まだ公開されていない engine だと解決できません。

### 全ページが `Propshaft::MissingAssetError` で 500 になる

CSS がビルドされていません。`bin/dev` を使うか、サーバー起動前に上記の
`tailwindcss:build` を実行してください。

### `LoadError: Could not open library 'vips.so.42'`

`vips -v` で libvips が入っているか確認してください。
入っていなければ[インストール手順](https://www.libvips.org/install.html)に従ってください。

## クレジット

[Spree Commerce](https://spreecommerce.org) の上に構築し、
[Spree Starter](https://github.com/spree/spree_starter) を fork したものです。
Spree は本当によくできたオープンソースプラットフォームで、
このスターターが成立しているのも彼らが土台を作ってくれたからです。
役に立ったと感じたら [Spree](https://github.com/spree/spree) に star を付けたり、
[Slack コミュニティ](https://slack.spreecommerce.org)に参加してみてください。

## ライセンス

本家 Spree Starter を引き継いで MIT です。[LICENSE](LICENSE) を参照してください。

なお、このスターターが依存する `ba_spree` の gem 群は AGPL-3.0-or-later です。
Spree 5.3.6 のストアフロント / 管理画面のソースを一部コピーして改変しているためです。
