require File.expand_path('../helper.rb', __FILE__)

class CurrencyTest < Test::Unit::TestCase
  def setup
    Fixer::Currency.collection.drop
    Fixer::Currency.create_indexes
  end

  def test_upsert
    hsh = { :code => 'USD',
            :date => Time.new(2011, 9, 12),
            :rate => 1.3656 }
    2.times { Fixer::Currency.insert(hsh) }
    assert_equal 1, Fixer::Currency.collection.find().to_a.size
  end
end
