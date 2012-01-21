Fixer
=====

Fixer wraps the [foreign exchange rate feeds][ecb] of the European Central
Bank.

It optionally persists to a MongoDB-backed collection.

Installation
------------

Add Fixer to your Gemfile.

```ruby
gem 'fixer'
```

The ECB Feed
------------

```ruby
require 'fixer'

feed = Fixer.feed('all')
first = feed.first

first[:code] # => "USD"
first[:rate] # => 1.3656
feed.count # => 100353
```

Persistence
-----------

```ruby
require 'fixer/mongo'

Fixer.feed(90).save

money = Money.new(100, 'USD')
money.exchange_to('EUR').cents # => 129
money.exchange_to('EUR', 1.month.ago) # => 127
