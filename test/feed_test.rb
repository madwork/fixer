require File.expand_path('../helper.rb', __FILE__)

class FeedTest < Test::Unit::TestCase
  def test_invalid_feed_type
    assert_raise(ArgumentError) { Fixer::Feed.new('foo') }
  end

  def test_daily_feed
    VCR.use_cassette('fixer') do
      feed = Fixer::Feed.new('daily')
      fxs = feed.to_a
      assert_equal fxs.map { |e| e[:date] }.uniq.size, 1

      fx = fxs.first
      assert_kind_of Float, fx[:rate]
      assert_kind_of Time, fx[:date]
    end
  end

  def test_ninety_days_feed
    VCR.use_cassette('fixer') do
      feed = Fixer::Feed.new(90)
      fxs = feed.to_a
      assert fxs.size > 50 * 30
    end
  end

  def test_historical_feed
    VCR.use_cassette('fixer') do
      feed = Fixer::Feed.new('historical')
      fxs = feed.to_a
      assert fxs.size > 2500 * 30
    end
  end
end
