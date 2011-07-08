require "spec_helper"

describe Fixer do
  describe ".daily" do
    it "downloads daily rates" do
      rates = Fixer.daily

      rates.size.should eql 1
      rates.first.should be_a_snapshot
    end
  end

  describe ".ninety_days" do
    it "downloads rates for the past 90 days" do
      rates = Fixer.ninety_days

      # We should have more than 50 working days in a three-month period
      rates.size.should > 50
      rates.each do |rate|
        rate.should be_a_snapshot
      end
    end
  end

  it "downloads all rates since January 1st, 1999" do
    rates = Fixer.historical

    # We should have a lot of working days in history
    rates.size.should > 1000
    rates.each do |rate|
      rate.should be_a_snapshot
    end
  end
end
