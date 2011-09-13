require 'date'
require 'mongo'

module Fixer
  # A Currency.
  #
  # Structurally, a currency consists of an ISO code and a collection
  # of dated rates.
  class Currency
    # The collection in which rates are stored on the database.
    def self.collection
      Connection.database['currencies']
    end

    def self.create_indexes
      collection.create_index([["date", Mongo::DESCENDING]])
    end

    def self.find(code, date = Date.today)
      # collection.find({ 'code' => code, 'rates' => { 'date' => { '$lte' => date } } }, { :limit => 1 })
    end

    # Inserts a hash representing a currency snapshot into the
    # database.
    def self.upsert(hsh)
      selector = { 'code' => hsh[:code] }
      modifier = {
        '$addToSet' => {
          'rates' => {
            'date' => hsh[:date],
            'rate' => hsh[:rate]
          }
        }
      }

      collection.update(selector, modifier, :upsert => true)
    end

    # The ISO code of the currency.
    attr :code

    # The currency rate.
    attr :rate

    # The date the currency rate was recorded.
    attr :date
  end
end

# coll.index_information()
