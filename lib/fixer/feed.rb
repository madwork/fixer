require 'nokogiri'
require 'open-uri'

module Fixer
  # An enumerable wrapper to the European Central Bank current and
  # historical foreign exchange rates.
  class Feed
    include Enumerable

    # Returns a new feed wrapper.
    #
    # Takes a feed type, which may be one of the following:
    #
    # * daily
    # * historical
    # * 90
    def initialize(type)
      @type = case type.to_s
              when 'daily'      then 'daily'
              when '90'         then 'hist-90d'
              when 'historical' then 'hist'
              else raise ArgumentError, "Not a valid type"
              end
    end

    # Yields each currency provided by the feed to a given block.
    def each(&block)
      namespaces = xml.root.namespaces
      xml.xpath("/gesmes:Envelope/xmlns:Cube/xmlns:Cube", namespaces).
        each { |day|
          day.xpath('./xmlns:Cube').each { |fx|
            hsh = {
              :date => parse_date(day['time']),
              :code => fx['currency'],
              :rate => Float(fx['rate'])
            }
            yield hsh
          }
        }
    end

    # The feed body.
    def body
      open(url).read
    end

    # The feed URL.
    def url
      "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@type}.xml"
    end

    # A memoized XML object.
    def xml
      @xml ||= Nokogiri::XML(body)
    end

    # The feed body.
    def body
      open(url).read
    end

    private

    def parse_date(str)
      pattern = %r{^(\d{4})-(\d{2})-(\d{2})$}
      match = str.match(pattern)
      _, year, month, day = *match

      Time.new(year.to_i, month.to_i, day.to_i)
    end
  end
end
