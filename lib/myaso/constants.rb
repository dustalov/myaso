# encoding: utf-8

# Different constants used in Myaso.
#
class Myaso::Constants
  # Definitions of the noun.
  #
  NOUNS = [ 'NOUN', 'С' ]

  # Definitions of the pronoun.
  #
  PRONOUNS = [ 'PN', 'МС' ]

  # Definitions of the pronouned adjective.
  #
  PRONOUNS_ADJ = [ 'PN_ADJ', 'МС-П' ]

  # Definitions of the verb.
  #
  VERBS = [ 'Г', 'VERB', 'ИНФИНИТИВ' ]

  # Definintions of the adjective.
  #
  ADJECTIVE = [ 'ADJECTIVE', 'П' ]

  # Productive classes list.
  #
  PRODUCTIVE_CLASSES = NOUNS + VERBS + ADJECTIVE + [ 'Н' ]
end