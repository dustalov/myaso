# encoding: utf-8

class Myaso::TokyoCabinet::Stems < Myaso::Adapter
  def find id
    stems.get(id)
  end

  def set id, rule
    stems.put(id, rule)
  end

  def delete id
    stems.delete(id)
  end

  def find_by_stem_and_rule_set_id stem, rule_set_id
    TDBQRY.new(stems).tap do |q|
      q.addcond('stem', TDBQRY::QCSTREQ, stem.empty? ? nil : stem)
      q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      q.setlimit(1, 0)
    end.search.first
  end

  def has_stem? stem, rule_set_id = nil
    TDBQRY.new(stems).tap do |q|
      q.addcond('stem', TDBQRY::QCSTREQ, stem.empty? ? nil : stem)
      if rule_set_id
        q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      end
      q.setlimit(1, 0)
    end.search.any?
  end

  def select stem
    TDBQRY.new(stems).tap do |q|
      q.addcond('stem', TDBQRY::QCSTREQ, stem.empty? ? nil : stem)
    end.search
  end

  def select_by_ending ending, rule_set_id = nil
    TDBQRY.new(stems).tap do |q|
      q.addcond('stem', TDBQRY::QCSTREW, ending)
      if rule_set_id
        q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      end
    end.search
  end

  protected
    def stems
      @stems ||= client.storages[:stems]
    end
end
