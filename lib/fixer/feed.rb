require 'net/http'
require 'nokogiri'

module Fixer
   class Feed
     include Enumerable

     FEEDS = {
       current:     'daily',
       ninety_days: 'hist-90d',
       historical:  'hist'
     }

     def initialize(feed = :current)
       @feed = FEEDS[feed] or raise ArgumentError
     end

     def each(&block)
       xml
         .xpath('/gesmes:Envelope/xmlns:Cube/xmlns:Cube', namespaces)
         .each do |day|
           day.xpath('./xmlns:Cube').each do |fx|
             yield date:     day['time'],
                   iso_code: fx['currency'],
                   rate:     Float(fx['rate'])
           end
         end
     end

     private

     def body
       Net::HTTP.get uri
     end

     def namespaces
       xml.root.namespaces
     end

     def uri
       URI "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@feed}.xml"
     end

     def xml
       Nokogiri::XML body
     end
   end
end
