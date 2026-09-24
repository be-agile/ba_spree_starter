# ba_spree Starter

English | [日本語](README.ja.md)

**A ready-to-run Spree store, set up for Japan.**

This is a starter kit for [ba_spree](https://github.com/be-agile/ba_spree) — a set of
Spree Commerce extensions that make a Japanese storefront work out of the box:
address fields in Japanese order, all 47 prefectures, tax-inclusive pricing,
bank transfer and cash on delivery.

Clone it, run a handful of commands, and you have a working Japanese shop with
sample products to click through.

Supported Spree version: **5.3.6** · Ruby **3.3.7** · MySQL

---

## Requirements

- Ruby 3.3.7
- MySQL
- Redis (used by Sidekiq for background jobs)
- Node.js and Yarn (for building CSS)
- libvips (image processing — see [Troubleshooting](#troubleshooting))

## Installation

```bash
git clone https://github.com/be-agile/ba_spree_starter.git
cd ba_spree_starter

bundle install

bin/rails db:create db:migrate
bin/rails db:seed              # country, prefectures, tax, shipping, JPY, ja locale
bin/rails spree_sample:load    # Japanese sample products and orders

bin/dev
```

Then open http://localhost:3000.

### Please read these three notes

They cover the things that most often go wrong on a first run.

**1. Use `bin/dev`, not `rails server`.**

The compiled CSS is not checked into the repository, so a fresh clone has none.
`bin/dev` starts the server together with the Tailwind watchers that build it.
If you run `rails server` on its own, every page fails with:

```
Propshaft::MissingAssetError: The asset 'tailwind.css' was not found in the load path.
```

If you would rather run the server by itself, build the CSS first:

```bash
bin/rails tailwindcss:build
bin/rails spree:admin:tailwindcss:build
bin/rails server
```

**2. `db:seed` and `spree_sample:load` are two separate commands.**

`db:seed` configures the store for Japan but adds no products. The sample
catalogue lives in `spree_sample:load`. Skip it and you get a correctly
configured but completely empty shop — which looks broken, but isn't.

**3. `BA_SPREE_PATH` is optional.**

The ba_spree gems are published on RubyGems, so a plain `bundle install` is all
you need. Set `BA_SPREE_PATH` only when you want to develop the engines against
your own checkout rather than the published versions:

```bash
BA_SPREE_PATH=/path/to/giga-repeat/engines bundle install
```

With it set, the `Gemfile` follows the dependencies of `ba_spree.gemspec`
through the gemspecs in that directory, and loads every engine it finds from
there instead of RubyGems. There is no engine list to maintain in the `Gemfile`.

## What you get

`db:seed` configures the store for Japan:

- Country Japan, and all 47 prefectures
- A "日本" zone
- Consumption tax at 10% / 8% (reduced rate) / exempt
- Flat-rate shipping
- JPY currency and `ja` locale

`spree_sample:load` then adds a Japanese demo catalogue:

- 117 products with Japanese names (デニムシャツ, チェックシャツ …)
- 1,082 variants, with Japanese colour and size options
- 30 taxons (2026年 夏, サマーセール, ジャケット・コート …)
- Prices in whole yen, not the upstream `.99` dollar amounts
- Bank transfer (銀行振込) and cash on delivery (代金引換) payment methods
- Japanese shipping methods, including 宅配便 and ネコポス

The extensions themselves — Japanese address format, postal code autofill,
loyalty points, NP deferred payment, and the rest — are documented in the
[ba_spree README](https://github.com/be-agile/ba_spree).

## How this differs from the upstream Spree starter

This repository is a fork of [spree/spree_starter](https://github.com/spree/spree_starter).
The differences are:

| | Upstream | This starter |
|---|---|---|
| Database | PostgreSQL | MySQL |
| Payments | Stripe, PayPal | Bank transfer, cash on delivery (Japanese methods via ba_spree) |
| Klaviyo integration | Included | Removed |
| Sample data | English fixtures | Japanese products, taxons and addresses |
| Locale | English | Japanese (`ja`) |

Everything else — Devise for authentication, Sidekiq for background jobs,
Redis for caching — is inherited from upstream and unchanged.

## Running tests

```bash
bundle exec rspec
```

## Troubleshooting

### `bundle install` cannot resolve a `spree_*` gem with `BA_SPREE_PATH` set

Check that the gem in the error message exists directly under `BA_SPREE_PATH`
as `<gem name>/<gem name>.gemspec`. An engine that is not found there is fetched
from RubyGems instead, which fails if it has not been published yet.

### Every page returns 500 with `Propshaft::MissingAssetError`

The CSS has not been built. Use `bin/dev`, or run the two `tailwindcss:build`
tasks shown above before starting the server.

### `LoadError: Could not open library 'vips.so.42'`

Check that libvips is installed with `vips -v`. If it is missing, follow the
[installation instructions](https://www.libvips.org/install.html).

## Credits

Built on [Spree Commerce](https://spreecommerce.org), and forked from their
[Spree Starter](https://github.com/spree/spree_starter). Spree is a genuinely
good open-source platform, and this starter exists only because they made it
easy to build on. If you find it useful, consider giving
[Spree](https://github.com/spree/spree) a star and joining their
[Slack community](https://slack.spreecommerce.org).

## Licence

MIT, inherited from the upstream Spree Starter. See [LICENSE](LICENSE).

Note that the `ba_spree` gems this starter depends on are AGPL-3.0-or-later,
because they copy and modify parts of the Spree 5.3.6 storefront and admin.
