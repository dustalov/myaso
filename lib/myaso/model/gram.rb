# encoding: utf-8

class Myaso::Model::Gram < Struct.new(:normal,
                                      :part,
                                      :grammems,
                                      :flexia_id,
                                      :ancode,
                                      :lemma,
                                      :method)
  def assign(hash = {})
    normal, part, grammems, flexia_id, ancode, lemma, method =
      hash[:normal], hash[:part], hash[:grammems], hash[:flexia_id],
      hash[:ancode], hash[:lemma], hash[:method]
  end
end
