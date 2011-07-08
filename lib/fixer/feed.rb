require 'nokogiri'
require 'open-uri'

module Fixer
  class Feed
    def initialize(type)
      @type = type
    end

    def get
      doc = Nokogiri::XML(feed)
      doc.xpath('/gesmes:Envelope/xmlns:Cube/xmlns:Cube', doc.root.namespaces).map do |node|
        Builder.new(node).build
      end
    end

    private

    def feed
      open(path).read
    end

    def path
      "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@type}.xml"
    end
  end
end
