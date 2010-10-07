# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Fixer
  class << self
    def base_currency
      @base_currency || "USD"
    end

    def base_currency=(name)
      @base_currency = name
    end

    def daily
      get('daily')
    end

    def expire_cache
      @daily = nil
    end

    def historical
      get('hist')
    end

    def historical_90
      get('hist-90d')
    end

    def self.method_missing(sym, *args)
      # the first argument is a Symbol, so you need to_s it if you want to pattern match
      if method_sym.to_s =~ /^find_by_(.*)$/
        find($1.to_sym => arguments.first)
      else
        super
      end
    end

    private

    def cached_daily
      @daily ||= daily
    end

    def get(type)
      path  = "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{type}.xml"
      feed  = open(path).read
      doc   = Nokogiri::XML(feed)
      doc.xpath('/gesmes:Envelope/xmlns:Cube/xmlns:Cube', doc.root.namespaces).map do |snapshot|
        {
          :date   => snapshot['time'],
          :rates  => snapshot.xpath('./xmlns:Cube').map do |fx|
            {
              :currency => fx['currency'],
              :rate     => fx['rate']
            }
          end
        }
      end
    end
  end
end
