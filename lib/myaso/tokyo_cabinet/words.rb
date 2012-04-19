# encoding: utf-8

class Myaso::TokyoCabinet::Words < Myaso::Adapter
  include TokyoCabinet

  def find id
    words.get(id)
  end

  def set id, rule
    words.put(id, rule)
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

  protected
    def words
      @words ||= client.storages[:words]
    end
end
