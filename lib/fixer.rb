require 'fixer/feed'

# A Ruby wrapper to the current and historical foreign exchange rate feeds of
# the European Central Bank.
module Fixer
  # Returns a new feed.
  #
  # @param [#to_s] type
  # @option type [Object] 'daily'
  # @option type [Object] '90'
  # @option type [Object] 'all'
  #
  # @return [Fixer::Feed] a feed
  def self.feed(type)
    Feed.new(type)
  end
end
