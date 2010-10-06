# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Fixer
  BASE_URL = 'http://www.ecb.europa.eu/stats/eurofxref/'

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
      url = BASE_URL + "eurofxref-#{type}.xml"
      feed = open(url).read
      doc = Nokogiri::XML(feed)
      doc.xpath('/gesmes:Envelope/xmlns:Cube/xmlns:Cube', doc.root.namespaces).map do |snapshot|
        {
          :date   => snapshot['time'],
          :rates  => snapshot.xpath('./xmlns:Cube').map do |fx|
            {
              :currency     => fx['currency'],
              :rate         => fx['rate']
            }
          end
        }
      end
    end
  end
end
