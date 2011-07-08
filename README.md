Fixer
====

Fixer wraps the current and historical
[foreign exchange rate feeds](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html)
of the European Central Bank.

Usage
-----

```ruby
Fixer.daily
Fixer.ninety_days
Fixer.historical
```

A sample implementation:

```ruby
# Migration
class CreateForeignExchanges < ActiveRecord::Migration
  def self.up
    create_table :foreign_exchanges do |t|
      t.string :iso_code
      t.float :rate

      t.timestamps
    end

    add_index :foreign_exchanges, :iso_code
  end

  def self.down
    drop_table :foreign_exchanges
  end
end

# Model
class ForeignExchange < ActiveRecord::Base
  class << self
    # Returns an exchange rate quote.
    #
    # Accepts a counter currency code and an optional base currency code.
    # Latter defaults to EUR if none is specified.
    def quote(counter, base='EUR')
      find_rate_by_currency(counter) / find_rate_by_currency(base)
    end

    private

    def find_rate_by_currency(iso_code)
      where(:iso_code => iso_code).first.rate
    end
  end
end

# Bank
class ECB < Money::Bank::Base
  class << self
    def refresh
      hashes = Fixer.daily.first[:rates]
      hashes.push({ :currency => "EUR", :rate => 1.0 })
      hashes.each do |hash|
        fx = ForeignExchange.find_or_initialize_by_iso_code(hash[:currency])
        fx.rate = hash[:rate]
        fx.save
      end
    end
  end

  def exchange_with(from, to_currency)
    rate = ForeignExchange.quote(to_currency.iso_code, from.currency.iso_code)
    Money.new((from.cents * rate).floor, to_currency)
  end
end

# Initializer
Money.default_bank = ECB.new
```
