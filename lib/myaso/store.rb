# encoding: utf-8

class Myaso
  require 'oklahoma_mixer'

  # Wrapper around TokyoCabinet to make storage routines
  # nice and pretty.
  class Store
    attr_reader :rules, :lemmas, :prefixes, :gramtab, :rulefreq

    # Initialize TokyoCabinet storage in defined
    # <tt>storage_path</tt>:
    #   <tt>rules.tcb</tt>,
    #   <tt>lemmas.tcb</tt>,
    #   <tt>prefixes.tch</tt>,
    #   <tt>gramtab.tct</tt>,
    #   <tt>rulefreq.tch</tt>.
    def initialize(storage_path)
      rules_path = File.join(storage_path, 'rules.tcb')
      @rules = OklahomaMixer.open(rules_path)

      lemmas_path = File.join(storage_path, 'lemmas.tcb')
      @lemmas = OklahomaMixer.open(lemmas_path)

      prefixes_path = File.join(storage_path, 'prefixes.tch')
      @prefixes = OklahomaMixer.open(prefixes_path)

      gramtab_path = File.join(storage_path, 'gramtab.tct')
      @gramtab = OklahomaMixer.open(gramtab_path)

      rulefreq_path = File.join(storage_path, 'rulefreq.tch')
      @rulefreq = OklahomaMixer.open(rulefreq_path)
    end

    # Close the all opened databases.
    def close
      rules.close
      lemmas.close
      prefixes.close
      gramtab.close
      rulefreq.close
    end
  end
end