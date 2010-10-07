Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds provided by the European Central Bank](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

I am also throwing in a *minimal* cache. Use if it suits you or implement your own.

Bonus: Use the Money gem.

Usage
-----

Download the current, 90-day, or historical rates:

    Fixer.daily
    Fixer.historical_90
    Fixer.historical
    
Use the built-in cache. The base currency will default to €:

    cache = Fixer::Cache
    cache.to_usd # a EUR/USD quote
    => 1.397

Switch base currency to USD and get a USD/EUR quote:

    cache.base = "USD"
    cache.to_eur
    => 0.7158

Cache is a singleton class and should hit the ECB only once in a long-running process.
