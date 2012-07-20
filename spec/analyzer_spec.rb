# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

require 'myaso/msd/english'

module Myaso
  describe Analyzer do
    let(:tmpdir) { Dir.mktmpdir }
    let(:myaso) { Myaso::TokyoCabinet.new(tmpdir, :manage) }
    let(:language) { Myaso::MSD::English }

    let(:analyzer) { Myaso::Analyzer.new(myaso, language) }

    subject { analyzer }

    before { populate_tokyo_cabinet! myaso }

    after do
      myaso.close!
      FileUtils.remove_entry_secure tmpdir
    end

    it 'should analyze known word' do
      analysis = subject.lookup('cat')

      analysis.must_be_kind_of Array
      analysis.size.must_equal 1

      result = analysis.first
      result.must_be_kind_of Analyzer::Result

      result.word_id.must_equal '1'
      result.stem.id.must_equal 1
      result.rule.id.must_equal 1

      result.msd.language.must_equal language
    end

    it 'should not analyze unknown word' do
      analysis = subject.lookup('dog')

      analysis.must_be_kind_of Array
      analysis.size.must_equal 0
    end

    it 'should lemmatize by stem' do
      analysis = subject.lookup('cats').first

      result = subject.lemmatize(analysis.stem.id)
      result.must_be_kind_of Analyzer::Result

      lemma = myaso.words.assemble(result.word_id)
      lemma.must_equal 'cat'
    end

    it 'should inflect words' do
      analysis = subject.lookup('cat').first

      result = subject.inflect(analysis.stem.id, 'Nc-p')
      result.must_be_kind_of Analyzer::Result

      inflection = myaso.words.assemble(result.word_id)
      inflection.must_equal 'cats'
    end
  end
end
