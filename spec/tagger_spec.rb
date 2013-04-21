# encoding: utf-8

require_relative 'spec_helper'

describe Myaso::Tagger do
  let(:lexicon) { File.expand_path('../data/test.lex', __FILE__) }
  let(:ngrams) { File.expand_path('../data/test.123', __FILE__) }
  subject { Myaso::Tagger.new(ngrams, lexicon) }

  describe 'q(w1, w2, w3)' do
    it 'returns 0 if there is no such tags combination' do
      subject.q('c', 'd', 'e').must_equal(0)
      subject.q('c', 'e', 'a').must_equal(0)
    end

    it 'counts the quotient between trigram and bigram counts othewise' do
      subject.q('a', 'a', 'a').must_equal(1/6.0)
      subject.q('b', 'a', 'b').must_equal(1/3.0)
    end
  end

  describe 'e(word, tag)' do
    it 'returns 0 if there is no such bunch word => tag' do
      subject.e('братишка', 'b').must_equal(0)
      subject.e('проголодался', 'c').must_equal(0)
    end

    it 'counts the quotient between count(word, tag) and ngrams(tag)' do
      subject.e('братишка', 'a').must_equal(1/22.0)
      subject.e('принес', 'e').must_equal(2/6.0)
    end
  end

  describe 'learn!' do
    it 'should learn with the same results as in gold standard' do
      subject.words_tags.must_equal(Myaso::Fixtures::WORDS_TAGS)
      subject.ngrams.must_equal(Myaso::Fixtures::NGRAMS)
    end
  end
end
