# codeless_code

Search and print [The Codeless Code](http://thecodelesscode.com/contents)
fables.

## Current Options

```
Usage: codeless_code [INFO]
       codeless_code [OPTION]... [FILTER]... [NUMBER]
Print or filter Codeless Code fables.
Info
    --list-translations
    -h, --help
Options
    --format                one of: raw, term (default)
Series Filters
    -S, --series
    -Ss, --series-start     series starts with
    -Se, --series-end       series ends with
    -hS, --has-series       has series listed
    -nS, --no-series        no series listed
Title Filters
    -T, --title
    -Ts, --title-start      title starts with
    -Te, --title-end        title ends with
    -hT, --has-title        has title listed
    -nT, --no-title         no title listed
Number Filters
    -N, --number            number (this is the default argument)
    -Ng, --number-gte       number or greater
    -Nl, --number-lte       number or lower
    -hN, --has-number       has number listed
    -nN, --no-number        no number listed
Language Filters
    -l, -L, --lang          language code (default: en)
Translator Filters
    -r, --translator        translator's name (default: first one, alphabetically)
    -R, --translator-exact  translator's name, case-sensitive (default: first one, alphabetically)
Date Filters
    -D, --date              publish date
    -Da, --date-after       publish date or after
    -Db, --date-before      publish date or before
    -nD, --no-date          no publish date listed
Geekiness Filters
    -G, --geekiness         geekiness rating
    -Gg, --geekiness-gte    geekiness rating or greater
    -Gl, --geekiness-lte    geekiness rating or lower
    -nG, --no-geekiness     no geekiness rating
Name Filters
    -A, --name
    -As, --name-start       name starts with
    -Ae, --name-end         name ends with
    -nA, --no-name          no name listed
Credits Filters
    -C, --credits
    -Cs, --credits-start    credits starts with
    -Ce, --credits-end      credits ends with
    -hC, --has-credits      has credits listed
    -nC, --no-credits       no credits listed
Tagline Filters
    -I, --tagline
    -Is, --tagline-start    tagline starts with
    -Ie, --tagline-end      tagline ends with
    -hI, --has-tagline      has tagline listed
    -nI, --no-tagline       no tagline listed```

## Contributing to codeless_code

  * Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
  * Check out the issue tracker to make sure someone already hasn't requested
    it and/or contributed it.
  * Fork the project.
  * Start a feature/bugfix branch.
  * Commit and push until you are happy with your contribution.
  * Make sure to add tests for it. This is important so I don't break it in a
    future version unintentionally.
  * Please try not to mess with the Rakefile, version, or history. If you want
    to have your own version, or is otherwise necessary, that is fine, but
    please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2018 Jon Sangster. See LICENSE.txt for further details.
