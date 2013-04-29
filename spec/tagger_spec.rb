# encoding: utf-8

require_relative 'spec_helper'

describe Myaso::Tagger do
  let(:lexicon) { File.expand_path('../data/test.lex', __FILE__) }
  let(:ngrams) { File.expand_path('../data/test.123', __FILE__) }
  subject { Myaso::Tagger.new(ngrams, lexicon) }

  describe 'q(w1, w2, w3)' do
    it 'counts the quotient between trigram and bigram counts othewise' do
      subject.q('a', 'a', 'a').must_be_close_to 0.225, 0.001
      subject.q('b', 'a', 'b').must_be_close_to 0.278, 0.001
    end
  end

  describe 'e(word, tag)' do
    it 'returns 0 if there is no such bunch word => tag' do
      subject.e('братишка', 'b').must_equal(0)
      subject.e('проголодался', 'c').must_equal(0)
    end

    it 'counts the quotient between count(word, tag) and ngrams(tag)' do
      subject.e('братишка', 'a').must_equal(1 / 26.0)
      subject.e('принес', 'e').must_equal(2 / 6.0)
    end
  end

  describe 'learn!' do
    it 'should learn with the same results as in gold standard' do
      subject.words_tags.must_equal(Myaso::Fixtures::WORDS_TAGS)
      subject.ngrams.must_equal(Myaso::Fixtures::NGRAMS)
      subject.interpolations.must_equal(Myaso::Fixtures::INTERPOLATIONS)
      subject.words_counts.must_equal(Myaso::Fixtures::WORDS_COUNTS)
    end
  end

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
