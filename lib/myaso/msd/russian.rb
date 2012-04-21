# encoding: utf-8

# The Russian MULTEXT-East specifications were developed in
# the scope of an effort to produce a publicly available tagged
# corpus of Russian; this corpus and accompanying resources are
# available from http://corpus.leeds.ac.uk/mocky/. The
# morphosyntactic specifications and corpus are documented in:
# Serge Sharoff, Mikhail Kopotev, Tomaž Erjavec, Anna Feldman,
# Dagmar Divjak. Designing and evaluating Russian tagsets.
# In Proc. LREC 2008, Marrakech, May, 2008.
#
# http://nl.ijs.si/ME/V4/msd/html/msd-ru.html
#
# This specification was translated into Ruby language
# by Dmitry A. Ustalov.
#
module Myaso::MSD::Russian
  # Russian Noun.
  #
  NOUN = {
    code: 'N',
    attrs: [
      [ :type, {
        common: 'c',
        proper: 'p'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n',
        common: 'c'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        vocative: 'v',
        locative: 'l',
        instrumental: 'i'
      } ],
      [ :animate, {
        no: 'n',
        yes: 'y'
      } ],
      [ :case2, {
        partitive: 'p',
        locative: 'l'
      } ]
    ]
  }

  # Russian Verb.
  #
  VERB = {
    code: 'V',
    attrs: [
      [ :type, {
        main: 'm',
        auxiliary: 'a'
      } ],
      [ :vform, {
        indicative: 'i',
        imperative: 'm',
        conditional: 'c',
        infinitive: 'n',
        participle: 'p',
        gerund: 'g'
      } ],
      [ :tense, {
        present: 'p',
        future: 'f',
        past: 's'
      } ],
      [ :person, {
        first: '1',
        second: '2',
        third: '3'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n'
      } ],
      [ :voice, {
        active: 'a',
        passive: 'p',
        medial: 'm'
      } ],
      [ :definiteness, {
        short_art: 's',
        full_art: 'f'
      } ],
      [ :aspect, {
        progressive: 'p',
        perfective: 'e',
        biaspectual: 'b'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        locative: 'l',
        instrumental: 'i'
      } ]
    ]
  }

  # Russian Adjective.
  #
  ADJECTIVE = {
    code: 'A',
    attrs: [
      [ :type, {
        qualificative: 'f',
        possessive: 's'
      } ],
      [ :degree, {
        positive: 'p',
        comparative: 'c',
        superlative: 's'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        locative: 'l',
        instrumental: 'i'
      } ],
      [ :definiteness, {
        short_art: 's',
        full_art: 'f'
      } ]
    ]
  }

  # Russian Pronoun.
  #
  PRONOUN = {
    code: 'P',
    attrs: [
      [ :type, {
        personal: 'p',
        demonstrative: 'd',
        indefinite: 'i',
        possessive: 's',
        interrogative: 'q',
        relative: 'r',
        reflexive: 'x',
        negative: 'z',
        nonspecific: 'n'
      } ],
      [ :person, {
        first: '1',
        second: '2',
        third: '3'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        vocative: 'v',
        locative: 'l',
        instrumental: 'i'
      } ],
      [ :syntactic_type, {
        nominal: 'n',
        adjectival: 'a',
        adverbial: 'r'
      } ],
      [ :animate, {
        no: 'n',
        yes: 'y'
      } ]
    ]
  }

  # Russian Adverb.
  #
  ADVERB = {
    code: 'R',
    attrs: [
      [ :degree, {
        positive: 'p',
        comparative: 'c',
        superlative: 's'
      } ]
    ]
  }

  # Russian Adposition.
  #
  ADPOSITION = {
    code: 'S',
    attrs: [
      [ :type, {
        preposition: 'p'
      } ],
      [ :formation, {
        simple: 's',
        compound: 'c'
      } ],
      [ :case, {
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        locative: 'l',
        instrumental: 'i'
      } ]
    ]
  }

  # Russian Conjunction.
  #
  CONJUNCTION = {
    code: 'C',
    attrs: [
      [ :type, {
        coordinating: 'c',
        subordinating: 's'
      } ],
      [ :formation, {
        simple: 's',
        compound: 'c'
      } ],
      [ :coord_type, {
        sentence: 'p',
        words: 'w'
      } ],
      [ :sub_type, {
        negative: 'z',
        positive: 'p'
      } ],
    ]
  }

  # Russian Numeral.
  #
  NUMERAL = {
    code: 'M',
    attrs: [
      [ :type, {
        cardinal: 'c',
        ordinal: 'o',
        multiple: 'm',
        collect: 'l'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        locative: 'l',
        instrumental: 'i'
      } ],
      [ :form, {
        digit: 'd',
        roman: 'r',
        letter: 'l'
      } ],
      [ :blank, {} ],
      [ :blank, {} ],
      [ :blank, {} ],
      [ :animate, {
        no: 'n',
        yes: 'y'
      } ]
    ]
  }

  # Russian Particle.
  #
  PARTICLE = {
    code: 'Q',
    attrs: [
      [ :formation, {
        simple: 's',
        compound: 'c'
      } ]
    ]
  }

  # Russian Interjection.
  #
  INTERJECTION = {
    code: 'I',
    attrs: [
      [ :formation, {
        simple: 's',
        compound: 'c'
      } ]
    ]
  }

  # Russian Abbreviation.
  #
  ABBREVIATION = {
    code: 'Y',
    attrs: [
      [ :syntactic_type, {
        nominal: 'n',
        adverbial: 'r'
      } ],
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        locative: 'l',
        instrumental: 'i'
      } ]
    ]
  }

  # Russian Residual.
  #
  RESIDUAL = {
    code: 'X',
    attrs: []
  }

  # Russian Crutch.
  #
  # Some AOT definitions are written for meta <tt>*</tt> part of speech,
  # so we have to implement it.
  #
  CRUTCH = {
    code: '*',
    attrs: [
      [ :gender, {
        masculine: 'm',
        feminine: 'f',
        neuter: 'n',
        common: 'c'
      } ],
      [ :animate, {
        no: 'n',
        yes: 'y'
      } ],
      [ :number, {
        singular: 's',
        plural: 'p'
      } ],
      [ :case, {
        nominative: 'n',
        genitive: 'g',
        dative: 'd',
        accusative: 'a',
        vocative: 'v',
        locative: 'l',
        instrumental: 'i'
      } ],
      [ :case2, {
        partitive: 'p',
        locative: 'l'
      } ],
      [ :aspect, {
        progressive: 'p',
        perfective: 'e',
        biaspectual: 'b'
      } ],
      [ :voice, {
        active: 'a',
        passive: 'p',
        medial: 'm'
      } ],
      [ :tense, {
        present: 'p',
        future: 'f',
        past: 's'
      } ],
      [ :person, {
        first: '1',
        second: '2',
        third: '3'
      } ],
      [ :definiteness, {
        short_art: 's',
        full_art: 'f'
      } ],
      [ :degree, {
        positive: 'p',
        comparative: 'c',
        superlative: 's'
      } ]
    ]
  }

  # Actual part-of-speech mapping.
  #
  CATEGORIES = {
    noun: NOUN,
    verb: VERB,
    adjective: ADJECTIVE,
    pronoun: PRONOUN,
    adverb: ADVERB,
    adposition: ADPOSITION,
    conjunction: CONJUNCTION,
    numeral: NUMERAL,
    particle: PARTICLE,
    interjection: INTERJECTION,
    abbreviation: ABBREVIATION,
    residual: RESIDUAL,
    crutch: CRUTCH
  }
end
