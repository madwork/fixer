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
          var_name = "@#{base}_#{counter}".to_sym
          rate = instance_variable_get(var_name)
          return rate unless rate.nil?

          rate = quote(counter) / quote(base)
          rate = (rate * 10000).round.to_f / 10000
          instance_variable_set(var_name, rate)
          rate
        else
          super
        end
      end

      private

      def rates
        begin
          @rates ||= Fixer.daily.first[:rates].push({ :currency => "EUR", :rate => "1.0" })
        rescue
          raise Error, "Cache not valid"
        end
      end

      def quote(counter)
        rate = rates.detect { |rate| rate[:currency] == counter }
        raise(Error, "Currency not valid") if rate.nil?
        rate[:rate].to_f
      end
    end
  end

  class Error < StandardError; end
end
