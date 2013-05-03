# encoding: utf-8

require_relative 'spec_helper'

describe 'CLI' do
  it 'should print help when ran without arguments' do
    invoke('').must_include 'Commands:'
    invoke('').must_include 'Options:'
  end

  it 'should print version information' do
    invoke('-v').must_include 'Myaso v%s' % Myaso::VERSION
    invoke('--version').must_equal invoke('-v')
  end

  it 'should print help' do
    invoke('-h').must_include 'Commands:'
    invoke('-h').must_include 'Options:'
    invoke('--help').must_equal invoke('-h')
  end

  it 'should evaluate parameters' do
    invoke('-e', 'puts :hi; exit').must_include 'hi'
    invoke('--eval', 'puts :hi; exit').must_equal(
      invoke('-e', 'puts :hi; exit'))
  end

  it 'should consider the ngrams parameter' do
    invoke('-n', 'test', '-e', 'puts options.ngrams; exit').
      must_include 'test'
    invoke('--ngrams', 'test', '-e', 'puts options.ngrams; exit').
      must_equal(invoke('-n', 'test', '-e', 'puts options.ngrams; exit'))
  end

  it 'should consider the lexicon parameter' do
    invoke('-l', 'test', '-e', 'puts options.lexicon; exit').
      must_include 'test'
    invoke('--lexicon', 'test', '-e', 'puts options.lexicon; exit').
      must_equal(invoke('-l', 'test', '-e', 'puts options.lexicon; exit'))
  end

  it 'should annotate sentences' do
    stdout = invoke('-n', 'spec/data/test.123', '-l', 'spec/data/test.lex',
      'tagger', stdin: "братишка\nя\nтебе\nпокушать\nпринес")
    stdout.must_equal ["братишка\ta", "я\tb", "тебе\tb", "покушать\td",
      "принес\te"]
  end
end
