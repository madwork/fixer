module Fixer
  class Builder
    def initialize(node)
      @node = node
    end

    def build
      {
        :date   => @node['time'],
        :rates  => @node.xpath('./xmlns:Cube').map do |fx|
          {
            :currency => fx['currency'],
            :rate     => fx['rate']
          }
        end
      }
    end
  end
end
