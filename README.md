Fixer
====

Fixer wraps the current and historical [foreign exchange rate feeds](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html) of the European Central Bank.

Usage
-----

    Fixer.daily
    Fixer.historical_90
    Fixer.historical

To get things rolling, here is a minimal implementation with a Mongoid-based model and and a bank:

    class ForeignExchangeRate
      include Mongoid::Document
      field :currency
      field :rate, :type => Float
      key   :currency

      def self.quote(counter,base)
        find(counter.downcase).rate / find(base.downcase).rate).round(4)
      end
    end

    class ECB < Money::Bank::Base
      def self.refresh
        hashes = Fixer.daily.first[:rates]
        hashes.push({ :currency => "EUR", :rate => "1.0" })
        hashes.each do |hash|
          fx = ForeignExchangeRate.find_or_create_by(
            :currency => hash[:currency])
          fx.rate = hash[:rate]
          fx.update
        end
      end

      def exchange_with(from, to_currency)
        counter = to_currency.iso_code
        base    = from.currency.iso_code
        rate    = ForeignExchangeRate.quote(counter, base)
        Money.new((from.cents * rate).floor, to_currency)
      end
    end
