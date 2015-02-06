# encoding: utf-8

require_relative 'spec_helper'

describe Myaso::Mystem do
  describe 'analysis of dictionary words' do
    subject { Myaso::Mystem.analyze('СТАЛИ') }

    it 'is ambiguous' do
      subject.length.must_equal 2
    end

    it 'is a dictionary word' do
      subject.each { |s| s.quality.must_equal :dictionary }
    end

    it 'lemmatizes' do
      subject.map(&:lemma).sort!.must_equal %w(сталь становиться)
    end

    it 'normalizes' do
      subject.each { |s| s.form.must_equal 'стали' }
    end
  end

  describe 'analysis of bastard words' do
    subject { Myaso::Mystem.analyze('дОлБоЯщЕрА') }

    it 'is unambiguous' do
      subject.length.must_equal 1
    end

    it 'lemmatizes' do
      subject.first.lemma.must_equal 'долбоящер'
    end

    it 'normalizes' do
      subject.first.form.must_equal 'долбоящера'
    end

    it 'is really a dictionary word' do
      subject.first.quality.must_equal :bastard
    end
  end

  describe 'inflection' do
    it 'is not implemented yet' do
      proc { Myaso::Mystem.inflect('кот', nil) }.must_raise NotImplementedError
    end
  end
end
