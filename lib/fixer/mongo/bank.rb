module Fixer
  module Mongo
    class Bank < Money::Bank::Base
      def exchange_with(from, to_currency, date = Time.now)
        base    = from.currency.iso_code
        counter = to_currency.iso_code
        rate    = Fixer.quote(counter, base, date)

        Money.new((from.cents * rate).floor, to_currency)
      end
    end
  end
end
