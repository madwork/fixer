module Fixer
  module Mongo
    class Currency
      attr :collection

      def initialize(iso_code)
        @iso_code = iso_code.downcase
        @collection = Connection.database[@iso_code]
      end

      def count
        collection.count
      end

      def rate(date = Time.now)
        return 1.0 if @iso_code == 'eur'

        sel  = { 'd' => { '$lte' => date } }
        opts = { :limit => 1,
                 :sort  => [['d', ::Mongo::DESCENDING]] }
        doc = collection.find(sel, opts).first

        doc ? doc['r'] : nil
      end

      def upsert(date, rate)
        sel = { 'd' => date }
        mod = { 'd' => date, 'r' => rate }

        collection.update(sel, mod, :upsert => true)
      end
    end
  end
end
