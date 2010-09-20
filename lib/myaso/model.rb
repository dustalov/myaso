# encoding: utf-8

class Myaso
  module Model
    extend ActiveSupport::Autoload

    autoload :Gramtab, 'myaso/models/gramtab'
    autoload :Lemma, 'myaso/models/lemma'
    autoload :Prefix, 'myaso/models/prefix'
    autoload :Rule, 'myaso/models/rule'
  end
end
