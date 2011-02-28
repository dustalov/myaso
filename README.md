# myaso

Tasty, fresh [myaso](http://github.com/eveel/myaso)
is a morphological analyzer, written in shiny
[Ruby](http://ruby-lang.org/).

![Delicious myaso](https://github.com/eveel/myaso/raw/master/myaso.jpg)

Mostly based on
[pymorphy](http://bitbucket.org/kmike/pymorphy/)
by Mikhail Korobov. Seriously, pymorphy is a great
software written in [ugly](http://python.org/) programming
language, so let fix this dirty mistake.

As usual, myaso is [Suckless](http://suckless.ru/).
Stupid pussies and tolerance-faggots are not welcome,
thanks.

## Feature List

* [Thor](http://github.com/carlhuda/thor)-based command-line
interface.
* Ability to start the Myaso IRB session to work with
morphological information over our awesome objects.
* Grammatic databases converter (*.tab files).
* Morphology databases converter (*.mrd files).
* GNU DBM storage via [Shkuph](https://github.com/eveel/shkuph)
middleware.
* Word morphology prediction, hahaha.

### To-Do List

* Decouple Myaso::Converter into the
[Myasorubka](https://github.com/eveel/myasorubka).
* Code documentation.
* Tests (sorry guys).
* Inflection, delicious candies, many sweets, etc.

## Basic Usage

Here comes typical myaso use cases.

### Morphological Analysis

Direct usage of Myaso, just check it out:
    % bin/myaso predict лопатка --store=share/ru
    [#<struct Myaso::Model::Gram
      normal="ЛОПАТКА",
      part="С",
      grammems=["жр", "ед", "им"],
      flexia_id=46,
      ancode="га",
      lemma="ЛОПАТК",
      method="predict_by_lemma('ЛОПАТКА')">]

Obviously, this functionality can by accessed by API:
    store = Myaso::Store.new('share/ru')
    morph = Myaso::Morphology.new(store)
    p morph.predict('лопатка')

### Myaso IRB Session

Thanks to IRB, you can use Myaso classes to solve your tasks
easily, like this:
    % bin/myaso irb
    irb: warn: can't alias help from irb_help.
    >> base = 'ЛОПАТ';
    ?> store = Myaso::Store.new('share/ru');
    ?> lemma = store.lemmas[base]
    => #<struct Myaso::Model::Lemma flexia_id=15>
    >> flexia = store.flexias[lemma.flexia_id];
    ?> words = flexia.forms.map do |form|
    ?>   [ form.prefix, base, form.suffix ].join
    >> end.inspect
    => ["ЛОПАТКА", "ЛОПАТКИ", "ЛОПАТКЕ", "ЛОПАТКУ", "ЛОПАТКОЙ",
        "ЛОПАТКОЮ", "ЛОПАТКЕ", "ЛОПАТКИ", "ЛОПАТОК", "ЛОПАТКАМ",
        "ЛОПАТКИ", "ЛОПАТКАМИ", "ЛОПАТКАХ"]

### Help viewing

    Yeah! You can view basic help messages on myaso:
    % bin/myaso help
    Tasks:
      myaso convert STORAGE_PATH MORPHS GRAMTAB --encoding=ENCODING  # Convert ao...
      myaso help [TASK]                                              # Describe a...
      myaso irb                                                      # Start the ...
      myaso predict WORD --store=STORE                               # Perform th...
      myaso version                                                  # Print the ...

### Dictonaries converting

Tasty myaso support only databases from awesome
[aot.ru](http://aot.ru/) website. First, you should convert
aot`s dictionaries to Myaso-usable format.

When you [download](http://wiki.github.com/eveel/myaso/dictonaries-from-aotru)
these dictonaries, just run myaso converter.

Let assume following:

* morphs file is located at `share/dicts/ru/rmorphs.mrd`;
* gramtab file is located at `share/dicts/ru/rgramtab.tab`;
* encoding of both files are `cp1251`.

So run myaso like this and enjoy the resulting content of `ru`
directory:
    % bin/myaso convert 'share/ru' \
        'share/dicts/ru/rmorphs.mrd' \
        'share/dicts/ru/rgramtab.tab' \
        --encoding=cp1251

### Application Programming Interface

Tasty myaso has nice (and tasty, of course) API for Ruby
programmers. See myaso at
[RubyDoc.info](http://rubydoc.info/gems/myaso),
but currently documentation really sucks: you'd better
read source code.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so
  I don't break it in a future version
  unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is
  fine but bump version in a commit by itself
  I can ignore when I pull)
* Send me a pull request. Bonus points for
  topic branches.

## Copyright

Copyright (c) 2010-2011 Dmitry A. Ustalov.
See LICENSE for details.
