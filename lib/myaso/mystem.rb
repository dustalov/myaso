module Myaso::Mystem extend self
  extend FFI::Library

  ffi_lib './libmystem_c_binding.so'

  attach_function :MystemAnalyze,          [:pointer, :int], :pointer
  attach_function :MystemAnalysesCount,    [:pointer],       :int
  attach_function :MystemDeleteAnalyses,   [:pointer],       :void

  attach_function :MystemLemma,            [:pointer, :int], :pointer
  attach_function :MystemLemmaText,        [:pointer],       :pointer
  attach_function :MystemLemmaTextLen,     [:pointer],       :int
  attach_function :MystemLemmaForm,        [:pointer],       :pointer
  attach_function :MystemLemmaFormLen,     [:pointer],       :int
  attach_function :MystemLemmaQuality,     [:pointer],       :int
  attach_function :MystemLemmaStemGram,    [:pointer],       :string
  attach_function :MystemLemmaFlexGram,    [:pointer],       :pointer
  attach_function :MystemLemmaFlexGramNum, [:pointer],       :int
  attach_function :MystemLemmaFlexLen,     [:pointer],       :int
  attach_function :MystemLemmaRuleId,      [:pointer],       :int

  attach_function :MystemGenerate,         [:pointer],       :pointer
  attach_function :MystemDeleteForms,      [:pointer],       :void
  attach_function :MystemFormsCount,       [:pointer],       :int

  attach_function :MystemForm,             [:pointer, :int], :pointer
  attach_function :MystemFormText,         [:pointer],       :pointer
  attach_function :MystemFormTextLen,      [:pointer],       :int
  attach_function :MystemFormStemGram,     [:pointer],       :pointer
  attach_function :MystemFormFlexGram,     [:pointer],       :pointer

  QUALITY = {
    0x00000000 => :dictionary,
    0x00000001 => :bastard,
    0x00000002 => :sob,
    0x00000004 => :prefixoid,
    0x00000008 => :foundling,
    0x00000010 => :bad_request,
    0x00010000 => :from_english,
    0x00020000 => :to_english,
    0x00040000 => :untranslit,
    0x00100000 => :overrode,
    0x01000000 => :fix
  }.freeze

  Analysis = Struct.new(:lemma, :form, :quality, :stem_grammemes, :flex_grammemes, :flex_length, :rule_id)

  def analyze(word)
    symbols = as_symbols(word)

    analyzes = MystemAnalyze(symbols, word.length)
    analyzes_count = MystemAnalysesCount(analyzes)

    analyzes_count.times.map do |i|
      lemma = MystemLemma(analyzes, i)

      lemma_text = MystemLemmaText(lemma)
      lemma_text_len = MystemLemmaTextLen(lemma)

      form_text = MystemLemmaForm(lemma)
      form_text_len = MystemLemmaFormLen(lemma)

      flex_grammemes_raw = MystemLemmaFlexGram(lemma)
      flex_grammemes_len = MystemLemmaFlexGramNum(lemma)

      Analysis.new(
        as_string(lemma_text, lemma_text_len),              # lemma
        as_string(form_text, form_text_len),                # form
        QUALITY[MystemLemmaQuality(lemma)],                 # quality
        MystemLemmaStemGram(lemma).bytes,                   # stem_grammemes
        as_strings(flex_grammemes_raw, flex_grammemes_len), # flex_grammemes
        MystemLemmaFlexLen(lemma),                          # flex_length
        MystemLemmaRuleId(lemma)                            # rule_id
      )
    end
  ensure
    MystemDeleteAnalyses(analyzes)
  end

  def inflect(word, form)
    raise NotImplementedError, 'the library is not yet completed'
  end

  protected

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
