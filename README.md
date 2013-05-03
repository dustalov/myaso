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
model = Myaso::Tagger::Model.new('model.123', 'model.lex')
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
the separate repository: <https://github.com/ustalov/myaso-web>.

## Acknowledgement
This work is partially supported by UrB RAS grant №RCP-12-P10.

## Contributing
1. Fork it;
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Added some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create new Pull Request.

## Build Status [<img src="https://secure.travis-ci.org/ustalov/myaso.png"/>](https://travis-ci.org/ustalov/myaso)

## Dependency Status [<img src="https://gemnasium.com/ustalov/myaso.png"/>](https://gemnasium.com/ustalov/myaso)

## Code Climate [<img src="https://codeclimate.com/github/ustalov/myaso.png"/>](https://codeclimate.com/github/ustalov/myaso)

## Copyright

Copyright (c) 2010-2013 [Dmitry Ustalov]. See LICENSE for details.

[Dmitry Ustalov]: http://eveel.ru
