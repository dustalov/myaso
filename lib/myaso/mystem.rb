module Myaso::Mystem extend self
  class Lemma < Struct.new(:lemma, :form, :quality, :msd, :stem_grammemes, :flex_grammemes, :flex_length, :rule_id)
    def forms
      Myaso::Mystem.forms(lemma, rule_id)
    end

    def inflect(grammemes)
      Myaso::Mystem.inflect(forms, grammemes)
    end

    def inspect
      '#<%s lemma=%s msd="%s">' % [self.class.name, to_s.inspect, msd]
    end

    def to_s
      lemma
    end
  end

  class Form < Struct.new(:form, :msd, :stem_grammemes, :flex_grammemes)
    def inspect
      '#<%s form=%s msd="%s">' % [self.class.name, to_s.inspect, msd]
    end

    def to_s
      form
    end
  end

  def analyze(word)
    Array.new.tap do |lemmas|
      invoke_analyze(as_symbols(word), word.length) do |lemma|
        lemma_text = MystemLemmaText(lemma)
        lemma_text_len = MystemLemmaTextLen(lemma)

        form_text = MystemLemmaForm(lemma)
        form_text_len = MystemLemmaFormLen(lemma)

        stem_grammemes = MystemLemmaStemGram(lemma).bytes
        flex_grammemes_raw = MystemLemmaFlexGram(lemma)
        flex_grammemes_len = MystemLemmaFlexGramNum(lemma)
        flex_grammemes = as_strings(flex_grammemes_raw, flex_grammemes_len)
        grammemes = stem_grammemes | flex_grammemes

        lemmas << Lemma.new(
          as_string(lemma_text, lemma_text_len),        # lemma
          as_string(form_text, form_text_len),          # form
          QUALITY[MystemLemmaQuality(lemma)],           # quality
          Myasorubka::Mystem::Binary.to_msd(grammemes), # msd
          stem_grammemes,                               # stem_grammemes
          flex_grammemes,                               # flex_grammemes
          MystemLemmaFlexLen(lemma),                    # flex_length
          MystemLemmaRuleId(lemma)                      # rule_id
        )
      end
    end
  end

  def forms(word, rule_id)
    Array.new.tap do |forms|
      invoke_analyze(as_symbols(word), word.length) do |lemma|
        next unless rule_id == MystemLemmaRuleId(lemma)

        invoke_generate(lemma) do |form|
          form_text = MystemFormText(form)
          form_text_len = MystemFormTextLen(form)

          stem_grammemes = MystemFormStemGram(form).bytes
          flex_grammemes_raw = MystemFormFlexGram(form)
          flex_grammemes_len = MystemFormFlexGramNum(form)
          flex_grammemes = as_strings(flex_grammemes_raw, flex_grammemes_len)
          grammemes = stem_grammemes | flex_grammemes

          forms << Form.new(
            as_string(form_text, form_text_len),          # form
            Myasorubka::Mystem::Binary.to_msd(grammemes), # msd
            stem_grammemes,                               # stem_grammemes
            flex_grammemes,                               # flex_grammemes
          )
        end
      end
    end
  end

  def inflect(forms, grammemes)
    forms.select do |form|
      grammemes.inject(true) { |r, (k, v)| r && form.msd.grammemes[k] == v }
    end
  end

  protected

  def invoke_analyze(symbols, length, &block)
    analyzes = MystemAnalyze(symbols, length)
    MystemAnalysesCount(analyzes).times do |i|
      block.call(MystemLemma(analyzes, i))
    end
  ensure
    MystemDeleteAnalyses(analyzes)
  end

  def invoke_generate(lemma, &block)
    forms = MystemGenerate(lemma)
    MystemFormsCount(forms).times do |i|
      block.call(MystemForm(forms, i))
    end
  ensure
    MystemDeleteForms(forms)
  end

  def as_symbols(string)
    FFI::MemoryPointer.
      new(:ushort, string.length).
      write_array_of_short(string.chars.map!(&:ord))
  end

  def as_string(symbols, length)
    symbols.read_array_of_ushort(length).
      map! { |c| c.chr(Encoding::UTF_8) }.
      join
  end

  def as_strings(grammemes, grammemes_length)
    Array.new.tap do |bytes|
      grammemes.get_array_of_string(0, grammemes_length).each do |ids|
        bytes << ids.bytes
      end
      bytes.flatten!
      bytes.uniq!
    end
  end
end
