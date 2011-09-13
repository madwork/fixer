require File.expand_path('../helper.rb', __FILE__)

class CurrencyTest < Test::Unit::TestCase
  def setup
    Fixer::Connection.database.collections.select {|c| c.name !~ /system/ }.each(&:remove)
  end

  def test_upsert
    fx = Fixer::Currency['USD']

    hsh = { :code => 'USD',
            :date => Time.new(2000, 1, 1),
            :rate => 1.1 }
    2.times { Fixer::Currency.upsert(hsh) }
    rates = fx.collection.find().to_a
    assert_equal 1, rates.size

    rate = rates.first
    assert_equal Time.new(2000, 1, 1), rate['date']
    assert_equal 1.1, rate['rate']

    hsh[:date] = Time.new(2000, 1, 2)
    hsh[:rate] = 1.2
    Fixer::Currency.upsert(hsh)
    rates = fx.collection.find().to_a
    assert_equal 2, rates.size
    rate = rates.last
    assert_equal Time.new(2000, 1, 2), rate['date']
    assert_equal 1.2, rate['rate']
  end

  def test_find_rate
    fx = Fixer::Currency['foo']
    (1..3).each do |cnt|
      hsh = { :date => Time.new(2000, 1, cnt),
              :rate => cnt.to_f }
      fx.collection.insert(hsh)
    end

    rate = fx.find_rate(Time.new(2000, 1, 2))
    assert_equal 2.0, rate

    rate = fx.find_rate(Time.new(2001, 1, 1))
    assert_equal 3.0, rate

    rate = fx.find_rate(Time.new(1999, 1, 1))
    assert_nil rate
  end

  def test_quote
    now = Time.now
    yesterday = now - 24 * 3600
    Fixer::Currency.upsert :code => 'USD',
                           :date => now,
                           :rate => 1.2
    Fixer::Currency.upsert :code => 'GBP',
                           :date => now,
                           :rate => 0.8
    Fixer::Currency.upsert :code => 'USD',
                           :date => yesterday,
                           :rate => 1.3
    assert_equal 1.5, Fixer::Currency.quote('USD', 'GBP')
    assert_equal 1.2, Fixer::Currency.quote('USD', 'EUR')
    assert_equal 1.3, Fixer::Currency.quote('USD', 'EUR', yesterday)
  end
end
