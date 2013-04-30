# encoding: utf-8

require_relative 'spec_helper'

describe Myaso::Tagger do
  let(:ngrams) { File.expand_path('../data/test.123', __FILE__) }
  let(:lexicon) { File.expand_path('../data/test.lex', __FILE__) }
  let(:model) { Myaso::Tagger::Model.new(ngrams, lexicon) }

  subject { Myaso::Tagger.new(model) }

  describe 'annotate(sentence)' do
    it 'should annotate sentences with tags' do
      subject.annotate(%w(братишка я тебе покушать принес)).
        must_equal(%w(a b b d e))
    end

    it 'should handle unknown words' do
      subject.annotate(%w(мир прекрасен , как никогда)).
        must_equal(%w(d d d d d))
    end
  end
end
