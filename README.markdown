Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds provided by the European Central Bank](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html).

Implement your own caching.

Usage
-----

    # Get daily rate
    Fixer.get('daily')
    
    # Get 90-day historical
    Fixer.get('hist-90d')
    
    # Get historical
    Fixer.get('hist')
    
    # It doesn't get any simpler than this.
