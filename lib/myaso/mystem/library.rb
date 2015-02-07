module Myaso::Mystem::Library
  extend FFI::Library

  begin
    ffi_lib ENV.fetch('MYSTEM_LIBRARY', Dir["{/{opt,usr}/{,local/}lib{,64},.}/libmystem_c_binding.{dylib,so}"])
  rescue LoadError
    fail 'The mystem library could not be loaded. '      \
         'Please install it and set the MYSTEM_LIBRARY ' \
         'environment variable to its path.'
  end

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
  attach_function :MystemFormStemGram,     [:pointer],       :string
  attach_function :MystemFormFlexGram,     [:pointer],       :pointer
  attach_function :MystemFormFlexGramNum,  [:pointer],       :int
end

Myaso::Mystem.send(:extend, Myaso::Mystem::Library)
