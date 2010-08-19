# encoding: utf-8

require 'helper'

class TestInflector < Test::Unit::TestCase
  context 'Myaso Inflector' do
    context 'Word Case' do
      should_inflect 'Котопес', 'Котопес'
      should_inflect 'ПАША', 'ПАША'
      should_inflect 'котопес', 'котопес'
    end

    context 'Basic Words' do
      should_inflect 'Москва', 'Москве', :case => :prepositional
      should_inflect 'бутявка', 'бутявками', :case => :prepositional,
        :number => :plural
      should_inflect 'Петрович', 'Петровичу', :case => :prepositional,
        :patronymic => true

      should_inflect '[[лошадь]] Пржевальского', 'лошади Пржевальского',
        :case => :dative
      should_inflect 'Москва', 'Москва', :case => :prepositional
      should_inflect '[[Москва]]-сити', 'Москве-сити', :case => :prepositional

      # funny joke comes here
      should_inflect 'суслики', 'сусликов', :case => :instrumental
    end

    context 'Names' do
      should_inflect 'Геннадий Петрович', 'Геннадия Петровича',
        :case => :accusative
      should_inflect 'Геннадий Петрович', 'Геннадию Петровичу',
        :case => :dative
      should_inflect 'Геннадий Петрович', 'Геннадием Петровичем',
        :case => :instrumental
      should_inflect 'Геннадий Петрович', 'Геннадии Петровиче',
        :case => :prepositional
    end

    context 'Complex Phrases' do
      initial = '[[лошадь]] Пржевальского и ' +
        '[[красный конь]] Кузьмы Петрова-Водкина'
      inflected = 'лошади Пржевальского и ' +
        'красному коню Кузьмы Петрова-Водкина'
      should_inflect initial, inflected, :case => :dative

      initial = 'тридцать восемь попугаев и Удав'
      inflected = 'тридцати восьми попугаям и Удаву'
      should_inflect initial, inflected, :case => :dative

      initial = 'Пятьдесят девять сусликов'
      inflected = 'Пятьюдесятью девятью сусликами'
      should_inflect initial, inflected, :case => :instrumental
    end
  end

  class << self
    def should_inflect(phrase, result, form = {})
      should "inflect '#{phrase}' in #{form.inspect} form is '#{result}'" do
        assert_equal result, subject.inflect(phrase, form)
      end
    end
  end
end
