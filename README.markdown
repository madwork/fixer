Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds provided by the European Central Bank](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

I am also throwing in a *minimal* cache. Use if it suits you or implement your own.

Bonus: Use the Money gem.

Usage
-----

    # Download the daily rates.
    Fixer.daily
    
    # Download the 90-day historical rates.
    Fixer.historical_90
    
    # Download all historical rates.
    Fixer.historical
    
    # Use the built-in cache.
    cache = Fixer::Cache
    cache.to_usd
    => 1.397
    cache.base = "EUR"
    cache.to_eur
    => 0.7158
    
    # It doesn't get any simpler than this.
