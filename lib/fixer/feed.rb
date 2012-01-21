require 'nokogiri'
require 'open-uri'

module Fixer
  # An ECB data feed of foreign exchange rates.
  class Feed
    include Enumerable

    # Creates a new feed.
    #
    # @param [#to_s] type
    # @option type [Object] 'daily'
    # @option type [Object] '90'
    # @option type [Object] 'all'
    #
    # @return [Fixer::Feed] a feed
    def initialize(type)
      @type = case type.to_s
              when 'daily' then 'daily'
              when '90'    then 'hist-90d'
              when 'all'   then 'hist'
              else raise ArgumentError, "#{type} is not a valid type"
              end
    end

    # @yield passes foreign exchange rate record to given block.
    def each(&block)
      namespaces = xml.root.namespaces
      xml
        .xpath("/gesmes:Envelope/xmlns:Cube/xmlns:Cube", namespaces)
        .each { |day|
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

    private

    def body
      open(url).read
    end

    def parse_date(str)
      pattern = %r{^(\d{4})-(\d{2})-(\d{2})$}
      match = str.match(pattern)
      _, year, month, day = *match

      Time.new(year.to_i, month.to_i, day.to_i)
    end

    def url
      "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@type}.xml"
    end

    def xml
      @xml ||= Nokogiri::XML(body)
    end
  end
end
