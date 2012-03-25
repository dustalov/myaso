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
      analysis = subject.analyze('cat')

      analysis.must_be_kind_of Array
      analysis.size.must_equal 1

      result = analysis.first

      result.must_be_kind_of Analyzer::Result

      result.word_id.must_equal '1'
      result.stem['id'].must_equal '1'
      result.rule['id'].must_equal '1'

      result.msd.language.must_equal language
      result.msd.to_s.must_equal 'Nc-s'
    end

    it 'should not analyze unknown word' do
      analysis = subject.analyze('dog')

      analysis.must_be_kind_of Array
      analysis.size.must_equal 0
    end
  end
end
