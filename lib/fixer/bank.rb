require 'money'

module Fixer
  class Bank < Money::Bank::Base
    def self.seed
      # hashes = Fixer.daily.first[:rates]
      # hashes.push({ :currency => "EUR", :rate => 1.0 })
      # hashes.each do |hash|
      #   fx = ForeignExchange.find_or_initialize_by_iso_code(hash[:currency])
      #   fx.rate = hash[:rate]
      #   fx.save
      # end
    end

    def exchange_with(from, to_currency, date = Time.now)
      rate = Currency.quote(to_currency.iso_code, from.currency.iso_code, date)

      Money.new((from.cents * rate).floor, to_currency)
    end
  end
end
