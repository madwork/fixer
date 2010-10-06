Fixer
====

Fixer is a Ruby wrapper to the [current and historical foreign exchange rate feeds](http://www.ecb.europa.eu/stats/exchange/eurofxref/html/index.en.html) provided by the European Central Bank.

== Usage

    # Get daily rate
    Fixer.get('daily')
    
    # Get 90-day historical
    Fixer.get('hist-90d)
