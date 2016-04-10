require 'net/http'
require 'oga'

module Fixer
  class Feed
    include Enumerable

    TYPES = {
      current: 'daily',
      ninety_days: 'hist-90d',
      historical: 'hist'
    }.freeze

    def initialize(type = :current)
      @type = TYPES.fetch(type) { raise ArgumentError }
    end

    def each
      document.xpath('/Envelope/Cube/Cube').each do |day|
        date = Date.parse(day.attribute('time').value)
        day.xpath('./Cube').each do |currency|
          yield(
            date: date,
            iso_code: currency.attribute('currency').value,
            rate: Float(currency.attribute('rate').value)
          )
        end
      end
    end

    private

    def document
      Oga.parse_xml(xml)
    end

    def xml
      Net::HTTP.get(url)
    end

    def url
      URI("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@type}.xml")
    end
  end
end
