module Myaso::Mystem::Library
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
end

Myaso::Mystem.send(:extend, Myaso::Mystem::Library)
