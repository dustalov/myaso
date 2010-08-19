# encoding: utf-8

require 'helper'

class TestPluralizer < Test::Unit::TestCase
  context 'Myaso Pluralizer' do
    context 'Single Words' do
      should_pluralize 'бутявка', 1, 'бутявка'
      should_pluralize 'бутявка', 2, 'бутявки'
      should_pluralize 'бутявка', 5, 'бутявок'
      should_pluralize 'Бутявка', 1, 'Бутявок'
    end

    context 'Phrase' do
      should_pluralize 'Геннадий Петрович', 8, 'Геннадиев Петровичей'
    end

    def should_pluralize(phrase, amount, result)
      should "pluralize '#{phrase}' (#{amount}) to #{result}" do
        assert_equal result, subject.pluralize(phrase, amount)
      end
    end
  end
end
