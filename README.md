# tasty myaso

Tasty, fresh **myaso** is a morphological analyzer,
written in shiny [Ruby](http://ruby-lang.org/).

Mostly based on [pymorphy](http://bitbucket.org/kmike/pymorphy/) by
Mikhail Korobov. Seriosuly, pymorphy is a great software written in
[ugly](http://python.org/) programming language,
so let fix this dirty mistake.

As usual, myaso is [Suckless](http://suckless.ru/).

## Feature List (read as «To-Do List», please)

* Command-Line Interface based on Thor.
* Grammatic Information converter.
* (TODO) TokyoTable storage.
* (TODO) Morphology Dictonaries converter.
* (TODO) Normalizer/Inflector/Pluralizer modules.

## Basic Usage

Tasty myaso supports only databases from awesome
[aot.ru](http://aot.ru/) website. First, you should convert
aot`s dictionaries to myaso-usable format (TokyoTable).

This is not implemented yet.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Dmitry A. Ustalov. See LICENSE for details.
