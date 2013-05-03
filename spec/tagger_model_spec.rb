# encoding: utf-8

require_relative 'spec_helper'

describe Myaso::Tagger::Model do
  let(:ngrams) { File.expand_path('../data/test.123', __FILE__) }
  let(:lexicon) { File.expand_path('../data/test.lex', __FILE__) }

  subject { Myaso::Tagger::Model.new(ngrams, lexicon) }

  describe '#q(t1,t2,t3)' do
    it 'counts the quotient between trigram and bigram counts othewise' do
      subject.q('a', 'a', 'a').must_be_close_to 0.224, 0.001
      subject.q('b', 'a', 'b').must_be_close_to 0.287, 0.001
    end
  end

  describe '#e(w|t)' do
    it 'returns 0 if there is no such bunch word => tag' do
      subject.e('братишка', 'b').must_equal(0)
      subject.e('проголодался', 'c').must_equal(0)
    end

    it 'counts the quotient between count(word, tag) and ngrams(tag)' do
      subject.e('братишка', 'a').must_equal(1 / 26.0)
      subject.e('принес', 'e').must_equal(2 / 6.0)
    end
  end

  describe '#learn!' do
    it 'should has the same ngrams as in the gold standard' do
      subject.ngrams.must_equal Myaso::Fixtures::NGRAMS
    end

    it 'should has the same lexicon as in the gold standard' do
      subject.lexicon.must_equal Myaso::Fixtures::LEXICON
    end

    it 'should has the same interpolations as in the gold standard' do
      subject.interpolations.must_equal Myaso::Fixtures::INTERPOLATIONS
    end
  end

  describe '#start_symbol' do
    it 'should be SENT' do
      subject.start_symbol.must_equal 'SENT'
    end
  end

  describe '#stop_symbol' do
    it 'should be SENT' do
      subject.stop_symbol.must_equal 'SENT'
    end
  end
end
