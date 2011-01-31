# myaso

Tasty, fresh [myaso](http://github.com/eveel/myaso)
is a morphological analyzer, written in shiny
[Ruby](http://ruby-lang.org/).

![Delicious myaso](myaso.jpg)

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

* Code documentation.
* Tests (sorry guys).
* More word prediction methods.
* Inflection, delicious candies, many sweets, etc.

## Basic Usage

Here comes typical myaso use cases.

### Myaso IRB Session

Thanks to IRB, you can use Myaso classes to solve your tasks
easily, like this:
    % ./myaso irb
    irb: warn: can't alias help from irb_help.
    >> base = 'ЛОПАТ';
    ?> store = Myaso::Store.new('../ru/');
    ?> lemma = store.lemmas[base]
    => #<struct Myaso::Model::Lemma flexia_id=15>
    >> flexia = store.flexias[lemma.flexia_id];
    ?> words = flexia.forms.map do |form|
    ?>   [ form.prefix, base, form.suffix ].join
    >> end.inspect
    => ["ЛОПАТКА", "ЛОПАТКИ", "ЛОПАТКЕ", "ЛОПАТКУ", "ЛОПАТКОЙ",
        "ЛОПАТКОЮ", "ЛОПАТКЕ", "ЛОПАТКИ", "ЛОПАТОК", "ЛОПАТКАМ",
        "ЛОПАТКИ", "ЛОПАТКАМИ", "ЛОПАТКАХ"]

It's just a beginning!

### Help viewing

Yeah! You can view basic help messages on myaso:
    % ./myaso help
    Tasks:
      myaso convert STORAGE_PATH MORPHS GRAMTAB --encoding=ENCODING  # Conver...
      myaso help [TASK]                                              # Descri...
      myaso irb                                                      # Start ...
      myaso version                                                  # Print ...

Very useful, isn't it? :3

### Dictonaries converting

Tasty myaso support only databases from awesome
[aot.ru](http://aot.ru/) website. First, you should convert
aot`s dictionaries to myaso-usable format.

When you [download](http://wiki.github.com/eveel/myaso/dictonaries-from-aotru)
these dictonaries, just run myaso converter.

Let assume following:

* morphs file is located at `share/dicts/ru/rmorphs.mrd`;
* gramtab file is located at `share/dicts/ru/rgramtab.tab`;
* encoding of both files are `cp1251`.

So run myaso like this and enjoy the resulting content of `ru`
directory:
    myaso convert 'share/ru' \
        'share/dicts/ru/rmorphs.mrd' \
        'share/dicts/ru/rgramtab.tab' \
        --encoding=cp1251

### Word Analysis

You can perform morphology analysis of some words,
according to converted dictionaries:
    myaso predict мясо --store=share/ru

After this, in your terminal appears something like:
    [#<struct Myaso::Model::Gram
      normal="МЯСО",
      part="С",
      grammems="ср,0",
      flexia_id=25,
      ancode="ем",
      lemma="МЯСО",
      method="predict_by_suffix('МЯСО')">]

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
