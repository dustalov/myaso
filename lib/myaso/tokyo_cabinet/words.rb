# encoding: utf-8

# @private
class Myaso::TokyoCabinet::Words < Myaso::Adapter
  include TokyoCabinet

  def find id
    return unless word = words.get(id)
    values = word.values_at('stem_id', 'rule_id')
    Myaso::Word.new(id.to_i, *values)
  end

  def set word, id = nil
    words.put(id || word.id, word.to_h.tap { |r| r.delete('id') })
  end

  def delete id
    words.delete(id)
  end

  def find_by_stem_id_and_rule_id stem_id, rule_id
    TDBQRY.new(words).tap do |q|
      q.addcond('stem_id', TDBQRY::QCNUMEQ, stem_id)
      q.addcond('rule_id', TDBQRY::QCNUMEQ, rule_id)
      q.setlimit(1, 0)
    end.search.first
  end

  def select stem_id, rule_id
    TDBQRY.new(words).tap do |q|
      q.addcond('stem_id', TDBQRY::QCNUMEQ, stem_id)
      q.addcond('rule_id', TDBQRY::QCNUMEQ, rule_id)
    end.search
  end

  def select_by_stem_id stem_id
    TDBQRY.new(words).tap do |q|
      q.addcond('stem_id', TDBQRY::QCNUMEQ, stem_id)
    end.search
  end

  def select_by_rule_id rule_id
    TDBQRY.new(words).tap do |q|
      q.addcond('rule_id', TDBQRY::QCNUMEQ, rule_id)
    end.search
  end

  def size
    words.size
  end

  def assemble id
    word = find(id)
    assemble_stem_rule(word['stem_id'], word['rule_id'])
  end

  def assemble_stem_rule stem_id, rule_id
    stem, rule = base.stems.find(stem_id), base.rules.find(rule_id)
    [rule.prefix || '', stem.stem || '', rule.suffix || ''].join
  end

  protected
    def words
      @words ||= base.storages[:words]
    end
end
