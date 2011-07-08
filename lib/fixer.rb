require 'fixer/feed'
require 'fixer/builder'

module Fixer
  extend self

  def daily
    Feed.new('daily').get
  end

  def historical
    Feed.new('hist').get
  end

  def historical_90
    Kernel.warn("[DEPRECATION] `historical_90` is deprecated.  Please use `ninety_days` instead.")
    ninety_days
  end

  def ninety_days
    Feed.new('hist-90d').get
  end
end
