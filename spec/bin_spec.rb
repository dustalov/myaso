# encoding: utf-8

require_relative 'spec_helper'

describe 'CLI' do
  it 'should print help when ran without arguments' do
    invoke('').must_include 'Commands:'
    invoke('').must_include 'Options:'
  end

  it 'should print version information' do
    invoke('-v').must_include 'Myaso v%s' % Myaso::VERSION
    invoke('--version').must_include 'Myaso v%s' % Myaso::VERSION
  end

  it 'should print help' do
    invoke('-h').must_include 'Commands:'
    invoke('-h').must_include 'Options:'

    invoke('--help').must_include 'Commands:'
    invoke('--help').must_include 'Options:'
  end

  it 'should evaluate parameters' do
    invoke('-e', 'puts :hi; exit').must_include 'hi'
    invoke('--eval', 'puts :hi; exit').must_include 'hi'
  end

  it 'should consider the ngrams parameter' do
    invoke('-n', 'test', '-e', 'puts options.ngrams; exit').
      must_include 'test'
    invoke('--ngrams', 'test', '-e', 'puts options.ngrams; exit').
      must_include 'test'
  end

  it 'should consider the lexicon parameter' do
    invoke('-l', 'test', '-e', 'puts options.lexicon; exit').
      must_include 'test'
    invoke('--lexicon', 'test', '-e', 'puts options.lexicon; exit').
      must_include 'test'
  end
end
