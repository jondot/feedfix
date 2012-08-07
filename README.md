# feedfix

A smarter Node.js based reverse-proxy that fixes crappy RSS/Atom/XML feeds that still live in the 90's where everyone had their own idea of non-ISO date formats.


# Usage

Currently there is one kind of transformation to make, which is on
dates:

    http://datefixer.example.com?url=http://idiots.rss.com/stupidRSS.xml&datefields=pubDate&datefmt=ddd+MMM+DD+HH:mm:ss+z+YYYY

This will convert all field values in `pubDate` to ISO date format,
where originally they had the form of `ddd MMM DD HH:mm:ss z YYYY`.

For how to compose formats, see [moment](http://momentjs.com).


# Dependencies
One implicit dependency is `libxml2` which `feedfix` uses implicitly, in
order to get good parsing performance. If you're hosting on Heroku, its
already there, if on your own servers, make sure to install `libxml2`
and its development headers.

 
# Heroku

This service should just snap into Heroku easily.

    $ git clone git://github.com/jondot/feedfix.git
    $ cd feedfix; heroku create;
    $ git push heroku master


## Contributing

Fork, implement, add tests, pull request, get my everlasting thanks and a respectable place here :).


## Copyright

Copyright (c) 2012- [Dotan Nahum](http://gplus.to/dotan) [@jondot](http://twitter.com/jondot). See MIT-LICENSE for further details.


