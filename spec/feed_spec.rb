require_relative 'helper'

module Fixer
  describe Feed do
    before { VCR.insert_cassette 'fixer' }
    after  { VCR.eject_cassette }

    let(:current)     { Feed.new }
    let(:ninety_days) { Feed.new :ninety_days }
    let(:historical)  { Feed.new :historical }

    it 'returns currency hashes' do
      currency = current.first
      currency[:date].must_be_kind_of     String
      currency[:iso_code].must_be_kind_of String
      currency[:rate].must_be_kind_of     Float
    end

    it 'downloads current rates' do
      current.count.must_be :<, 40
    end

    it 'downloads rates for the past 90 days' do
      ninety_days.count.must_be :>, 33 * 60
    end

    it 'downloads historical rates' do
      historical.count.must_be :>, 33 * 3000
    end
  end
end
