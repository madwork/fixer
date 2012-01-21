$LOAD_PATH << File.expand_path('../../lib', __FILE__)

require 'test/unit'
require 'vcr'
require 'webmock'
begin
  require 'pry'
rescue LoadError
end

require 'fixer/mongo'

VCR.config do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.stub_with :webmock
end

class FixerTest < Test::Unit::TestCase
  def setup
    Fixer::Mongo::Connection.database.collections
      .select { |c| c.name !~ /system/ }
      .each(&:remove)
  end

  def test_rate
    today        = Time.now
    yesterday    = today - 24 * 3600
    two_days_ago = yesterday - 24 * 3600

    fx = Fixer['foo']
    fx.upsert(yesterday, 1.0)
    fx.upsert(today, 1.2)

    assert_equal 1.0, fx.rate(yesterday)
    assert_equal 1.2, fx.rate(today)
    assert_nil fx.rate(two_days_ago)
  end

  def test_quote
    today     = Time.now
    yesterday = today - 24 * 3600

    Fixer['USD'].upsert(today, 1.2)
    Fixer['GBP'].upsert(today, 0.8)
    Fixer['USD'].upsert(yesterday, 1.3)

    assert_equal 1.5, Fixer.quote('USD', 'GBP')
    assert_equal 1.2, Fixer.quote('USD', 'EUR')
    assert_equal 1.3, Fixer.quote('USD', 'EUR', yesterday)
  end

  def test_invalid_feed_type
    assert_raise(ArgumentError) { Fixer.feed('foo') }
  end

  def test_daily_feed
    VCR.use_cassette('fixer') do
      feed = Fixer.feed('daily')
      fxs = feed.to_a
      assert_equal fxs.map { |e| e[:date] }.uniq.count, 1

      fx = fxs.first
      assert_kind_of Float, fx[:rate]
      assert_kind_of Time, fx[:date]
    end
  end

  def test_ninety_days_feed
    VCR.use_cassette('fixer') do
      feed = Fixer.feed(90)
      fxs = feed.to_a
      assert fxs.count > 50 * 30
    end
  end

  def test_historical_feed
    VCR.use_cassette('fixer') do
      feed = Fixer.feed('all')
      fxs = feed.to_a
      assert fxs.count > 2500 * 30
    end
  end

  def test_save_feed
    VCR.use_cassette('fixer') do
      Fixer.feed(90).save
    end

    assert Fixer['USD'].count > 1
  end

  def test_bank
    today        = Time.now
    yesterday    = today - 24 * 3600
    two_days_ago = yesterday - 24 * 3600

    fx = Fixer['USD']
    fx.upsert(yesterday, 1.29)
    fx.upsert(today, 1.3)

    eur = Money.new(100, 'EUR')
    usd = eur.exchange_to('USD')

    assert_equal 'USD', usd.currency.iso_code
    assert_equal 130, usd.cents
    assert_equal 129, eur.exchange_to('USD', yesterday).cents
    assert_raise(RuntimeError) { eur.exchange_to('USD', two_days_ago) }
  end
end
