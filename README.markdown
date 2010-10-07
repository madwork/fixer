Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds provided by the European Central Bank](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

I am also throwing in a minimal cache. Use if it suits you or implement your own.

Usage
-----

Download the current, 90-day, or historical rates:

    Fixer.daily
    Fixer.historical_90
    Fixer.historical
    
Use the cache. Base currency defaults to €:

    cache = Fixer::Cache
    cache.to_usd # a EUR/USD quote
    => 1.397

Switch base currency to USD and get a USD/EUR quote:

    cache.base = "USD"
    cache.to_eur
    => 0.7158
