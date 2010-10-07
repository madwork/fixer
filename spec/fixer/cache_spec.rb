# encoding: utf-8
require 'spec_helper'

module Fixer
  describe Cache do
    before do
      @mock_rates = [
        { :currency=>"USD", :rate=>"1.3856" },
        { :currency=>"JPY", :rate=>"114.98" },
        { :currency=>"GBP", :rate=>"0.87260" },
        { :currency=>"CAD", :rate=>"1.4018" },
        { :currency=>"EUR", :rate=>"1.0" }
      ]
      @fx = Fixer::Cache
    end

    it "defaults to EUR as base currency" do
      @fx.base.should eql "EUR"
    end

    it "sets base currency" do
      @fx.base = "USD"
      @fx.base.should eql "USD"
    end

    it "quotes" do
      @fx.send(:quote, "USD").should eql 1.3856
    end

    it "caches" do
      @fx.instance_variable_set(:@rates, "foo")
      @fx.send(:rates).should eql "foo"
    end

    it "seeds cache" do
      @fx.send(:rates).detect { |rate| rate[:currency] == "USD" }[:rate].should_not be_nil
    end

    it "expires cache" do
      @fx.instance_variable_set(:@rates, "foo")
      @fx.expire
      @fx.instance_variable_get(:@rates).should be_nil
    end

    context "Quoting custom exchange rates" do
      it "returns an exchange rate" do
        @fx.instance_variable_set(:@rates, @mock_rates)
        @fx.to_usd.should eql 1.3856

        @fx.base = "GBP"
        @fx.to_usd.should eql 1.5879
      end

      it "raises an error if requested currency is not valid" do
        pending
      end

      it "raises an error if cache is not valid" do
        pending
      end
    end
  end
end
