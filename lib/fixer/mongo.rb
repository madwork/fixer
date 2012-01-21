require 'money'
require 'mongo'

require 'fixer'
require 'fixer/mongo/bank'
require 'fixer/mongo/connection'
require 'fixer/mongo/currency'

module Fixer
  # A shortcut to accees a currency collection.
  #
  # @param [String] iso_code The ISO code of a currency
  #
  # @return [Fixer::Mongo::Currency] a Currency collection
  def self.[](iso_code)
    Mongo::Currency.new(iso_code)
  end

  # Quotes the exchange rate of a counter currency against a base currency.
  # Optionally takes a date.
  #
  # @param [String] counter The counter currency
  # @param [String] base The base currency
  # @param [Time,nil] date The date the exchange takes place
  #
  # @return [Float] The requested exchange rate
  def self.quote(counter, base, date = Time.now)
    counter_rate = self.[](counter).rate(date)
    base_rate    = self.[](base).rate(date)
    raise 'Rate not available' if counter_rate.nil? || base_rate.nil?

    (10000 * counter_rate / base_rate).round.to_f / 10000
  end

  class Feed
    # Persists a feed to a Mongo collection.
    def save
      each do |hsh|
        Fixer[hsh[:code]].upsert(hsh[:date], hsh[:rate])
      end
    end
  end
end

Money.default_bank = Fixer::Mongo::Bank.new

class Money
  # Monkey-patch to support historical look-ups.
  def exchange_to(other_currency, date = Time.now)
    other_currency = Currency.wrap(other_currency)
    @bank.exchange_with(self, other_currency, date)
  end
end
