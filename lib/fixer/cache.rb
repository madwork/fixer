# encoding: utf-8
module Fixer
  class Cache
    class << self
      def base
        @base || "EUR"
      end

      def base=(name)
        @base = name
      end

      def expire
        @rates = nil
      end

      def method_missing(sym, *args, &block)
        if sym.to_s =~ /^to_(.*)$/
          counter = $1.upcase
          quotation = instance_variable_get("@#{base}_#{counter}")
          quotation ||= (
            rate = quote(counter) / quote(base)
            (rate * 10000).round.to_f / 10000
          )
        else
          super
        end
      end

      private

      def rates
        @rates ||= Fixer.daily.first[:rates].push({ :currency => "EUR", :rate => "1.0" })
      end

      def quote(counter)
        rates.detect { |rate| rate[:currency] == counter }[:rate].to_f
      end
    end
  end
end
