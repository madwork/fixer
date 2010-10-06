# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Fixer
  class << self
    def daily
      get('daily')
    end

    def historical
      get('hist')
    end

    def historical_90
      get('hist-90d')
    end
      
    private

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
