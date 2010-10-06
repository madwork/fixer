require 'spec_helper'

describe Fixer do
  it "downloads daily rates" do
    rates = Fixer.daily
    rates.size.should eql 1
    rates.first.should have_key :date
    rates.first.should have_key :rates
  end

  it "downloads 90-day historical" do
    rates = Fixer.historical_90
    # We should have more than 50 working days in a three-month period
    rates.size.should > 50
    rates.each do |rate|
      rate.should have_key :date
      rate.should have_key :rates
    end
  end

  it "downloads historical" do
    rates = Fixer.historical
    # We should have a lot of working days in history
    rates.size.should > 1000
    rates.each do |rate|
      rate.should have_key :date
      rate.should have_key :rates
    end
  end
end
