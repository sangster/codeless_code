# codeless_code

[![Gem Version](https://badge.fury.io/rb/codeless_code.svg)](https://badge.fury.io/rb/codeless_code)
[![Build Status](https://travis-ci.org/sangster/codeless_code.svg?branch=master)](https://travis-ci.org/sangster/codeless_code)
[![Maintainability](https://api.codeclimate.com/v1/badges/0b67f813b9c48e639888/maintainability)](https://codeclimate.com/github/sangster/codeless_code/maintainability)
<a href="https://codeclimate.com/github/sangster/codeless_code/test_coverage"><img src="https://api.codeclimate.com/v1/badges/0b67f813b9c48e639888/test_coverage" /></a>
[![GitHub license](https://img.shields.io/github/license/sangster/codeless_code.svg)](https://github.com/sangster/codeless_code/blob/master/LICENSE)

Search and print [The Codeless Code](http://thecodelesscode.com/contents)
fables.

## Installation

```sh
gem install codeless_code
```

## Usage

The main use-case is to filter through the fables available in a given language.
If multiple results are returned, their numbers and titles will be listed. If
only one result is found, it will be show to you.

When showing a single fable, it will be shown via your `PAGER`, if set. You may
force writing do STDOUT, by providing the `-o -` argument.

### Basic Examples

```sh
codeless_code           # list the fables for the default language (en)
codeless_code 123       # print the fable numbered as "123"
codeless_code --daily   # print the daily fable
codeless_code --random  # print a random fable
codeless_code -h        # get help
```

### Choosing a Data Set

There are different translations available, but different people

```sh
codeless_code -p /some/dir         # source the fables from a different folder
codeless_code --list-translations  # see what languages you can use
codeless_code -L zh                # list fables translated into Chinese
codeless_code -L ru -R edro        # list fables translated into Russian by edro

codeless_code -L fr --daily        # print today's French fable
```

### Filtering

You can combine many filters together. Only those fables which match every term
will be returned.

```sh
# Find fables written on or after 2014, with at least a geekiness rating of 2,
# and isn't part of a series
codeless_code -Da 2014 -Gg 2 -nS
```

### Listing

If the given filter returns more than one fable, they will be printed as a
list. By default, only the Number header and title of each fable will be
printed, one per line. You may use `-e` to specify additional headers to print.
Note that not every fable will have an entry for every header.

```sh
codeless_code -e Names,Geekiness
codeless_code -D 2015-06 -e Date -e Topics
```

### Current Options

```
Usage: codeless_code [INFO]

       codeless_code [OPTION]... [FILTER]... [NUMBER]

Print or filter Codeless Code fables.

Info
    -h, --help
    --list-translations
    --version

Options
    -c, --columns            when listing fables, format the output into columns
    -e, --headers            headers to include in the list output. may be repeated
    -f, --format             one of: raw, plain, or term (default)
    -o, --output             write to the given file. "-" for STDOUT
    -p, --path               path to directory of fables. see github.com/aldesantis/the-codeless-code
    --random                 select one fable, randomly, from the filtered list
    --random-set             select n fables, randomly, from the filtered list
    --daily                  select one fable, randomly, from the filtered listbased on today's date
    --trace                  print full error message if a fable fails to parse
    -s, --sort               when listing fables, sort by the given header
    -r, --reverse            when listing fables, reverse the order

Series Filters
    -S, --series
    -Ss, --series-start      series starts with
    -Se, --series-end        series ends with
    -hS, --has-series        has series listed
    -nS, --no-series         no series listed

Title Filters
    -T, --title
    -Ts, --title-start       title starts with
    -Te, --title-end         title ends with
    -hT, --has-title         has title listed
    -nT, --no-title          no title listed

Number Filters
    -N, --number             number (this is the default argument)
    -Ng, --number-gte        number or greater
    -Nl, --number-lte        number or lower
    -hN, --has-number        has number listed
    -nN, --no-number         no number listed

Language Filters
    -L, --lang               language code (default: en)

Translator Filters
    -R, --translator         translator's name (default: first one, alphabetically)
    -Rx, --translator-exact  translator's name, case-sensitive (default: first one, alphabetically)

Date Filters
    -D, --date               publish date
    -Da, --date-after        publish date or after
    -Db, --date-before       publish date or before
    -nD, --no-date           no publish date listed

Geekiness Filters
    -G, --geekiness          geekiness rating
    -Gg, --geekiness-gte     geekiness rating or greater
    -Gl, --geekiness-lte     geekiness rating or lower
    -nG, --no-geekiness      no geekiness rating

Name Filters
    -A, --name
    -As, --name-start        name starts with
    -Ae, --name-end          name ends with
    -nA, --no-name           no name listed

Credits Filters
    -C, --credits
    -Cs, --credits-start     credits starts with
    -Ce, --credits-end       credits ends with
    -hC, --has-credits       has credits listed
    -nC, --no-credits        no credits listed

Tagline Filters
    -I, --tagline
    -Is, --tagline-start     tagline starts with
    -Ie, --tagline-end       tagline ends with
    -hI, --has-tagline       has tagline listed
    -nI, --no-tagline        no tagline listed
```

## Development

### Testing

```sh
bundle exec rake test
COVERAGE=surewhynot bundle exec rake test

bundle exec guard
COVERAGE=1 bundle exec guard
```

### Contributing to codeless_code

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

Copyright (C) 2018  Jon Sangster

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received [a copy](LICENSE) of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.

The data this application uses by default, [*The Codeless
Code*](http://www.thecodelesscode.com/about) by Qi is licensed under a
[Creative Commons Attribution-NonCommercial 3.0 Unported
License](https://creativecommons.org/licenses/by-nc/3.0/deed.en_US).
