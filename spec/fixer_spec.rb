# encoding: utf-8
require 'spec_helper'

describe Fixer do
  before do
    @mock_daily = [ {
      :rates => [
        { :currency=>"USD", :rate=>"1.3856" },
        { :currency=>"JPY", :rate=>"114.98" },
        { :currency=>"GBP", :rate=>"0.87260" },
        { :currency=>"CAD", :rate=>"1.4018" } ],
      :date => "2010-10-06"
    } ]
  end

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

  it "defaults to USD as base currency" do
    Fixer.base_currency.should eql "USD"
  end

  it "sets base currency" do
    Fixer.base_dcurrency = "EUR"
    Fixer.base_currency.should eql "EUR"
  end

  context "Caching daily feed" do
    it "seeds cache" do
      Fixer.send(:cached_daily).first[:rates].detect { |rate| rate[:currency] == "USD" }[:rate].should_not be_nil
    end

    it "caches" do
      Fixer.instance_variable_set(:@daily, @mock_daily)
      Fixer.send(:cached_daily).first[:rates].detect { |rate| rate[:currency] == "USD" }[:rate].should eql "1.3856"
    end

    it "expires cache" do
      Fixer.instance_variable_set(:@daily, @mock_daily)
      Fixer.expire_cache
      Fixer.instance_variable_get(:@daily).should be_nil
    end
  end

  context "Exchange Rates" do
    it "returns an exchange rate" do
      Fixer.instance_variable_set(:@daily, @mock_daily)
      pending
    end

    it "raises an error if requested currency is not valid" do
      pending
    end

    it "raises an error if cache is not valid" do
      pending
    end
  end
end
