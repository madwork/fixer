Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds provided by the European Central Bank](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

Implement your own caching.

Usage
-----

    # Get daily rate
    Fixer.daily
    
    # Get 90-day historical
    Fixer.historical_90
    
    # Get historical
    Fixer.historical
    
    # It doesn't get any simpler than this.
