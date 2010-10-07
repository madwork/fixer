# encoding: utf-8
require 'spec_helper'

module Fixer
  describe Cache do
    let(:mock_rates) do
      [
        { :currency=>"USD", :rate=>"1.3856" },
        { :currency=>"JPY", :rate=>"114.98" },
        { :currency=>"GBP", :rate=>"0.87260" },
        { :currency=>"CAD", :rate=>"1.4018" },
        { :currency=>"EUR", :rate=>"1.0" }
      ]
    end

    let(:cache) do
      cache = Fixer::Cache
      cache.base = "EUR"
      cache.expire
      cache
    end

    it "sets base currency" do
      cache.base = "USD"
      cache.base.should eql "USD"
    end

    it "quotes" do
      cache.instance_variable_set(:@rates, mock_rates)
      cache.send(:quote, "USD").should eql 1.3856
    end

    it "caches" do
      cache.instance_variable_set(:@rates, "foo")
      cache.send(:rates).should eql "foo"
    end

    it "seeds cache" do
      cache.send(:rates).detect { |rate| rate[:currency] == "USD" }[:rate].should_not be_nil
    end

    it "expires cache" do
      cache.instance_variable_set(:@rates, "foo")
      cache.expire
      cache.instance_variable_get(:@rates).should be_nil
    end

    it "raises an error if cache not valid" do
      Fixer.stub!(:daily).and_return("foo")
      lambda { cache.send(:rates) }.should raise_error Fixer::Error, "Cache not valid"
    end

    it "returns an exchange rate" do
      cache.instance_variable_set(:@rates, mock_rates)
      cache.to_eur.should eql 1.0
      cache.to_usd.should eql 1.3856

      cache.base = "GBP"
      cache.to_gbp.should eql 1.0
      cache.to_usd.should eql 1.5879
    end

    it "caches requested exchange rates" do
      cache.instance_variable_set(:@rates, mock_rates)
      cache.to_usd
      cache.instance_variable_get(:@EUR_USD).should eql 1.3856
    end

    it "raises an error if counter currency not valid" do
      cache.instance_variable_set(:@rates, mock_rates)
      lambda { cache.to_foo }.should raise_error Fixer::Error, "FOO not a valid currency"
    end

    it "raises an error if base currency not valid" do
      cache.instance_variable_set(:@rates, mock_rates)
      cache.base = "BAR"
      lambda { cache.to_usd }.should raise_error Fixer::Error, "BAR not a valid currency"
    end
  end
end
