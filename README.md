# Myaso

Myaso [ˈmʲæ.sə] is a morphological analysis and synthesis library,
written in Ruby.

![Myaso](/eveel/myaso/raw/develop/myaso.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'myaso'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install myaso

## Usage

It is possible to perform morphological analysis with Myaso. In this
example, a dictionary in the Tokyo Cabinet format is stored in
`../myasorubka` path:

    $ myaso --tc-path ../myasorubka -i

After this, the `@tokyocabinet` variable will be allocated as a
ready for use `Myaso::TokyoCabinet` instance. All you need is
to prepare the analyzer and perform your tasks.

#### Dictionaries

Morphological dictionaries are preprocessed by the
[Myasorubka](https://github.com/eveel/myasorubka) tool.

These dictionaries are available in precompiled state
and can be [downloaded](https://github.com/eveel/myasorubka/downloads).

### Analysis

Morphological analysis is a main purpose of any morphological
analyzer. In Myaso this can be done in elegant way.

```ruby
# load the Russian morphosyntactic descriptions
require 'myaso/msd/russian'

# initialize the analyzer
analyzer = Analyzer.new(@tokyocabinet, MSD::Russian)

# analyze something
pp analyzer.analyze 'бублик'
```

The analysis results for word *бублик* are looking like this:

```
[#<struct Myaso::Analyzer::Result
  word_id="410728",
  stem={"rule_set_id"=>"21", "stem"=>"бублик", "msd_id"=>"687", "id"=>"18572"},
  rule={"msd"=>"Ncmsn", "rule_set_id"=>"21", "id"=>"502"},
  msd=
   #<Myaso::MSD:0x2b04e68 language=Myaso::MSD::Russian pos=:noun grammemes={:type=>:common, :gender=>:masculine, :number=>:singular, :case=>:nominative, :animate=>:no}>>,
 #<struct Myaso::Analyzer::Result
  word_id="410731",
  stem={"rule_set_id"=>"21", "stem"=>"бублик", "msd_id"=>"687", "id"=>"18572"},
  rule={"msd"=>"Ncmsa", "rule_set_id"=>"21", "id"=>"505"},
  msd=
   #<Myaso::MSD:0x2b03608 language=Myaso::MSD::Russian pos=:noun grammemes={:type=>:common, :gender=>:masculine, :number=>:singular, :case=>:accusative, :animate=>:no}>>]
```

### Lemmatization

It is possible to perform the word lemmatization. At this moment,
Myaso analyzer is able to lemmatize by word stem identifier:

```ruby
# take the first Myaso::Result of analysis
result = analyzer.analyze('люди').first

# lemmatize
analyzer.lemmatize(result.stem['id']) # => человек
```

## Further Work

I guess, the following things would be nice:

1. Implement backends for Sequel and ActiveRecord;
2. An algorithm of unknown word prediction.

## Acknowledgement

This work is supported by UrB RAS grants:

* 12-С-1-1012 «Облачная платформа для разработки и использования пакетов
прикладных программ и интеллектуальных систем»;
* [РЦП-12-П10] «Разработка морфологического анализатора русского языка в
качестве SaaS облачной платформы УрО РАН».

[РЦП-12-П10]: http://plove.eveel.ru/2012/01/20/morphological-grant

## Contributing

1. Fork it;
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Added some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create new Pull Request.

I highly recommend you to use git flow to make development process much
systematic and awesome.

## Build Status [<img src="https://secure.travis-ci.org/eveel/myaso.png"/>](http://travis-ci.org/eveel/myaso)

## Dependency Status [<img src="https://gemnasium.com/eveel/myaso.png?travis"/>](https://gemnasium.com/eveel/myaso)

## Copyright

Copyright (c) 2010-2012 [Dmitry A. Ustalov]. See LICENSE for details.

[Dmitry A. Ustalov]: http://eveel.ru
