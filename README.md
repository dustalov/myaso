# tasty myaso

Tasty, fresh [myaso](http://github.com/eveel/myaso)
is a morphological analyzer, written in shiny
[Ruby](http://ruby-lang.org/).

Mostly based on [pymorphy](http://bitbucket.org/kmike/pymorphy/) by
Mikhail Korobov. Seriously, pymorphy is a great software written in
[ugly](http://python.org/) programming language,
so let fix this dirty mistake.

As usual, myaso is [Suckless](http://suckless.ru/).

## Feature List (read as «To-Do List», please)

* Command-Line Interface based on Thor.
* TokyoCabinet Hash storage.
* Grammatic Information converter.
* Morphology Dictonaries converter.
* (TODO) Preanalysis dictionary processing.
* (TODO) Normalizer, Inflector and Pluralizer modules.

## Basic Usage

Here comes typical myaso use cases.

### Help viewing

Yeah! Thanks to [thor](http://github.com/wycats/thor), you can view
basic help messages on myaso:
    % ./myaso help
    Tasks:
      ./myaso convert TCH_PATH MORPHS GRAMTAB --encoding=ENCODING  # Conv...
      ./myaso help [TASK]                                          # Desc...
      ./myaso version                                              # Prin...
    % myaso -v
    myaso version 0.0.0

Very useful, isn't it? :3

### Dictonaries converting

Tasty myaso supports only databases from awesome
[aot.ru](http://aot.ru/) website. First, you should convert
aot`s dictionaries to myaso-usable format (TokyoCabinet Hash).

When you [download](http://wiki.github.com/eveel/myaso/dictonaries-from-aotru)
these dictonaries, just run myaso converter.

Let assume following:

* morphs file is located at _share/RusSrc/morphs.mrd_;
* gramtab file is located at _share/rgramtab.tab_;
* encoding of both files are _cp1251_.

So run myaso like this and enjoy the resulting _test.tch_ hash:
    myaso convert 'russian.tch' \
        'share/RusSrc/morphs.mrd' \
        'share/rgramtab.tab' \
        --encoding=cp1251

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
