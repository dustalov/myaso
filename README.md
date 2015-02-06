# Myaso

Myaso [ˈmʲæ.sə] is a morphological analysis and synthesis library,
written in Ruby.

![Myaso](myaso.jpg)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'myaso'
```

And then execute:

    $ bundle

Or install it:

    $ gem install myaso

## Usage

At the moment, Myaso has pretty fast part of speech (POS) tagger built on
hidden Markov models (HMMs). The tagging operation requires statistical
model to be trained.

Myaso supports trained models in the TnT format. One could be obtained
at the Serge Sharoff et al. resource called [Russian statistical taggers
and parsers](http://corpus.leeds.ac.uk/mocky/).

### Analysis

Since Yandex has released the [Mystem](https://tech.yandex.ru/mystem/)
analyzer in the form of shared library, it makes it possible to use
the analyzer through the usage of the foreign function interface.

Firstly, it is necessary to read and agree with the [mystem EULA].
Secondly, [download] and install the shared library for your operating
system. Finally, use Myaso and enjoy the benefits.

[mystem EULA]: http://legal.yandex.ru/mystem/
[download]: https://github.com/yandex/tomita-parser/releases/tag/v1.0

#### Analysis API

Myaso uses mystem library to process Russian words. That is quite simple.

```ruby
pp Myaso::Mystem.analyze('котёночка')
=begin
[#<struct Myaso::Mystem::Lemma
  lemma="котеночек",
  form="котёночка",
  quality=:dictionary,
  msd=#<Myasorubka::MSD::Russian msd="Ncmsay">,
  stem_grammemes=[136, 192, 201],
  flex_grammemes=[168, 174, 166],
  flex_length=6,
  rule_id=1525>]
=> [#<Myaso::Mystem::Lemma lemma="котеночек" msd="Ncmsay">]
=end
```

Myaso works fine even in case the given word is either ambiguous or
does not appear in the mystem's dictionary.

```ruby
pp Myaso::Mystem.analyze('аудисты')
=begin
[#<struct Myaso::Mystem::Lemma
  lemma="аудист",
  form="аудисты",
  quality=:bastard,
  msd=#<Myasorubka::MSD::Russian msd="Ncmpny">,
  stem_grammemes=[136, 192, 201],
  flex_grammemes=[165, 175],
  flex_length=1,
  rule_id=25>,
 #<struct Myaso::Mystem::Lemma
  lemma="аудистый",
  form="аудисты",
  quality=:bastard,
  msd=#<Myasorubka::MSD::Russian msd="A---p-s">,
  stem_grammemes=[128],
  flex_grammemes=[175, 183],
  flex_length=1,
  rule_id=65>]
=> [#<Myaso::Mystem::Lemma lemma="аудист" msd="Ncmpny">, #<Myaso::Mystem::Lemma lemma="аудистый" msd="A---p-s">]
=end
```

### Synthesis

The inflection features are not implemented yet. Sorry.

### Tagging

Myaso performs POS tagging using its own implementation of the Viterbi
algorithm on HMMs. The output has the following format: `token<TAB>tag`.

Please remember that tagger command line interface accepts only tokenized
texts — one token per line. For instance, the
[Greeb](http://nlpub.ru/wiki/Greeb) tokenizer can help you.
Don't be afraid to use another text tokenization or segmentation tool if
necessary.

```
% echo 'Как поспал, проголодался наверное?' | greeb | myaso -n snyat-msd.123 -l snyat-msd.lex tagger
Как	P-----r
поспал	Vmis-sma
,	,
проголодался	Vmis-sma
наверное	R
?	SENT
```

Unfortunately, current implementation of the tagger has two significant
drawbacks:

1. The tagger handles unknown words not so good. Sorry.
2. Tagging is fast inself, but requires pretty slow training procedure
running only once.

#### Tagging API

It is possible to embed the POS tagging feature in your own application
using API.

```ruby
model = Myaso::Tagger::TnT.new('model.123', 'model.lex')
tagger = Myaso::Tagger.new(model)
pp tagger.annotate(%w(Как поспал , проголодался наверное ?))
=begin
["P-----r", "Vmis-sma", ",", "Vmis-sma", "R", "SENT"]
=end
```

It is possible to significantly speed up the initialization process by
expicit setting of the interpolations vector. For instance, the TnT model
from http://corpus.leeds.ac.uk/mocky/ has the following (approximated)
linear interpolation coefficients: *k1 = 0.14*, *k2 = 0.30*, *k3 = 0.56*.
In the example these values are provided precisely.

```ruby
interpolations = [0.14095796503456284, 0.3032174211273352, 0.555824613838102]
model = Myaso::Tagger::TnT.new('model.123', 'model.lex', interpolations)
tagger = Myaso::Tagger.new(model)
pp tagger.annotate(%w(Как поспал , проголодался наверное ?))
=begin
["P-----r", "Vmis-sma", ",", "Vmis-sma", "R", "SENT"]
=end
```

Please note that you should perform tokenization of your text before
any processing. The [Greeb](http://nlpub.ru/wiki/Greeb) text segmentator
performs pretty well at this.

### Web Service

A source code of the Myaso-Web application is available at
the separate repository: <https://github.com/dustalov/myaso-web>.

## Acknowledgement

This work is partially supported by UrB RAS grant №RCP-12-P10.

## Contributing

1. Fork it;
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Added some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create new Pull Request.

## Build Status [<img src="https://secure.travis-ci.org/dustalov/myaso.png"/>](https://travis-ci.org/dustalov/myaso)

## Dependency Status [<img src="https://gemnasium.com/dustalov/myaso.png"/>](https://gemnasium.com/dustalov/myaso)

## Code Climate [<img src="https://codeclimate.com/github/dustalov/myaso.png"/>](https://codeclimate.com/github/dustalov/myaso)

## Copyright

Copyright (c) 2010-2015 [Dmitry Ustalov]. See LICENSE for details.

[Dmitry Ustalov]: https://ustalov.name/
