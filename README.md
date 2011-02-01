Fixer
====

Fixer wraps the current and historical [foreign exchange rate feeds](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html) of the European Central Bank.

Usage
-----

    Fixer.daily
    Fixer.historical_90
    Fixer.historical

The following is a simple implementation with a Mongoid model and a Ruby Money bank serving current rates:

    # The model
    class Currency
      include Mongoid::Document

      field :iso_code
      field :rate, :type => Float
      index :iso_code, :unique => true

      before_save :update_cache

      def self.quote(counter, base="EUR")
        rate_for(counter) / rate_for(base)
      end

      private

      def self.rates
        @rates ||= {}
      end

      def self.rate_for(iso_code)
        rates[iso_code.to_sym] ||= where(:iso_code => currency).first.rate
      end

      def update_cache
        self.class.rates[iso_code.to_sym] = rate
      end
    end

    # The bank
    class ECB < Money::Bank::Base
      def self.refresh
        hashes = Fixer.daily.first[:rates]
        hashes.push({ :currency => "EUR", :rate => 1.0 })
        hashes.each do |hash|
          fx = Currency.find_or_initialize_by(
            :iso_code => hash[:currency])
          fx.rate = hash[:rate]
          fx.save
        end
      end

      def exchange_with(from, to_currency)
        rate = Currency.quote(to_currency.iso_code, from.currency.iso_code)
        Money.new((from.cents * rate).floor, to_currency)
      end
    end

    # The initializer
    Money.default_bank = ECB.new
