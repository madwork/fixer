require 'mongo'

module Fixer
  # A collection of historical rates for a currency quoted against the
  # Euro as base currency.
  class Currency
    class << self; alias_method :[], :new; end

    # Quotes the rate a counter currency could be exchanged for a
    # unit of a base currency on a specified date or the current
    # date if latter is not specified.
    def self.quote(counter, base, date = Time.now)
      rate = new(counter).find_rate(date) / new(base).find_rate(date)

      (10000 * rate).round.to_f / 10000
    end

    # Upserts a hash representing a historical rate into the
    # collection of its currency.
    def self.upsert(hsh)
      mod  = hsh.dup
      code = mod.delete(:code)
      sel  = { 'date' => hsh[:date] }

      new(code).collection.update(sel, mod, :upsert => true)
    end

    def initialize(code)
      @code = code.downcase
    end

    # The collection object.
    def collection
      @collection ||= Connection.database["#{@code}_rates"]
    end

    # Returns the historical rate nearest to the specified date.
    #
    # Returns nil if no historical rate is available.
    def find_rate(date)
      return 1 if @code == 'eur'

      sel  = { 'date' => { '$lte' => date } }
      opts = { :limit => 1,
               :sort => [['date', Mongo::DESCENDING]] }
      doc = collection.find(sel, opts).first

      doc ? doc['rate'] : nil
    end
  end
end
