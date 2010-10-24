# encoding: utf-8

# Myaso flexia model.
#
class Myaso::Model::Flexia < Struct.new(:freq,
                                        :forms)
  class Form < Struct.new(:ancode,
                          :prefix,
                          :suffix)
  end
end
