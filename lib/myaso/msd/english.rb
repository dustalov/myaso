# encoding: utf-8

# English Specifications by Nancy Ide, Greg Priest-Dorman,
# Tomaž Erjavec, Tamas Varadi.
#
# http://nl.ijs.si/ME/V4/msd/html/msd-en.html
#
# This specification was translated into Ruby language
# by Dmitry A. Ustalov.
#
module Myaso::MSD::English
  # English Noun.
  #
  NOUN = {
    :code => 'N',
    :attrs => [
      [ :type, {
        :common => 'c',
        :proper => 'p'
      } ],
      [ :gender, {
        :masculine => 'm',
        :feminine => 'f',
        :neuter => 'n'
      } ],
      [ :number, {
        :singular => 's',
        :plural => 'p'
      } ]
    ]
  }

  # English Verb.
  #
  VERB = {
    :code => 'V',
    :attrs => [
      [ :type, {
        :main => 'm',
        :auxiliary => 'a',
        :modal => 'o',
        :base => 'b'
      } ],
      [ :vform, {
        :indicative => 'i',
        :conditional => 'c',
        :infinitive => 'n',
        :participle => 'p'
      } ],
      [ :tense, {
        :present => 'p',
        :past => 's'
      } ],
      [ :person, {
        :first => '1',
        :second => '2',
        :third => '3'
      } ],
      [ :number, {
        :singular => 's',
        :plural => 'p'
      } ]
    ]
  }

  # English Adjective.
  #
  ADJECTIVE = {
    :code => 'A',
    :attrs => [
      [ :type, {
        :qualificative => 'f'
      } ],
      [ :degree, {
        :positive => 'p',
        :comparative => 'c',
        :superlative => 's'
      } ]
    ]
  }

  # English Pronoun.
  #
  PRONOUN = {
    :code => 'P',
    :attrs => [
      [ :type, {
        :personal => 'p',
        :possessive => 's',
        :interrogative => 'q',
        :relative => 'r',
        :reflexive => 'x',
        :general => 'g',
        :ex_there => 't'
      } ],
      [ :person, {
        :first => '1',
        :second => '2',
        :third => '3'
      } ],
      [ :gender, {
        :masculine => 'm',
        :feminine => 'f',
        :neuter => 'n'
      } ],
      [ :number, {
        :singular => 's',
        :plural => 'p'
      } ],
      [ :case, {
        :nominative => 'n',
        :accusative => 'a'
      } ],
      [ :owner_number, {
        :singular => 's',
        :plural => 'p'
      } ],
      [ :owner_gender, {
        :masculine => 'm',
        :feminine => 'f'
      } ],
      [ :wh_type, {
        :relative => 'r',
        :question => 'q'
      } ],
    ]
  }

  # English Determiner.
  #
  DETERMINER = {
    :code => 'D',
    :attrs => [
      [ :type, {
        :demonstrative => 'd',
        :indefinite => 'i',
        :possessive => 's',
        :general => 'g'
      } ],
      [ :person, {
        :first => '1',
        :second => '2',
        :third => '3'
      } ],
      [ :number, {
        :singular => 's',
        :plural => 'p'
      } ],
      [ :owner_number, {
        :singular => 's',
        :plural => 'p'
      } ],
      [ :owner_gender, {
        :masculine => 'm',
        :feminine => 'f',
        :neuter => 'n'
      } ],
      [ :wh_type, {
        :relative => 'r',
        :question => 'q'
      } ]
    ]
  }

  # English Adverb.
  #
  ADVERB = {
    :code => 'R',
    :attrs => [
      [ :type, {
        :modifier => 'm',
        :specifier => 's'
      } ],
      [ :degree, {
        :positive => 'p',
        :comparative => 'c',
        :superlative => 's'
      } ],
      [ :wh_type, {
        :relative => 'r',
        :question => 'q'
      } ]
    ]
  }

  # English Adposition.
  #
  ADPOSITION = {
    :code => 'S',
    :attrs => [
      [ :type, {
        :preposition => 'p',
        :postposition => 't'
      } ]
    ]
  }

  # English Conjunction.
  #
  CONJUNCTION = {
    :code => 'C',
    :attrs => [
      [ :type, {
        :coordinating => 'c',
        :subordinating => 's'
      } ],
      [ :coord_type, {
        :initial => 'i',
        :non_initial => 'n'
      } ],
    ]
  }

  # English Numeral.
  #
  NUMERAL = {
    :code => 'M',
    :attrs => [
      [ :type, {
        :cardinal => 'c',
        :ordinal => 'o'
      } ],
    ]
  }

  # English Interjection.
  #
  INTERJECTION = {
    :code => 'I',
    :attrs => []
  }

  # English Abbreviation.
  #
  ABBREVIATION = {
    :code => 'Y',
    :attrs => []
  }

  # English Residual.
  #
  RESIDUAL = {
    :code => 'X',
    :attrs => []
  }

  # Actual part-of-speech mapping.
  #
  CATEGORIES = {
    :noun => NOUN,
    :verb => VERB,
    :adjective => ADJECTIVE,
    :pronoun => PRONOUN,
    :determiner => DETERMINER,
    :adverb => ADVERB,
    :adposition => ADPOSITION,
    :conjunction => CONJUNCTION,
    :numeral => NUMERAL,
    :interjection => INTERJECTION,
    :abbreviation => ABBREVIATION,
    :residual => RESIDUAL
  }
end
