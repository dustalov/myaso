# encoding: utf-8

class Myaso::TokyoCabinet::Rules < Myaso::Base::Adapter
  include TokyoCabinet

  def find id
    base.storages[:rules][id]
  end

  def set id, rule
    base.storages[:rules][id] = rule
  end

  def delete id
    base.storages[:rules].delete id
  end

  def find_rule rule_set_id, suffix, prefix = ''
    TDBQRY.new(rules).tap do |q|
      q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      q.addcond('suffix', TDBQRY::QCSTREQ, suffix.empty? ? nil : suffix)
      q.addcond('prefix', TDBQRY::QCSTREQ, prefix.empty? ? nil : prefix)
      q.setlimit(1, 0)
    end.search.first
  end

  def has_suffix? suffix
    TDBQRY.new(rules).tap do |q|
      q.addcond('suffix', TDBQRY::QCSTREQ, suffix.empty? ? nil : suffix)
      q.setlimit(1, 0)
    end.search.any?
  end

  def select_by_rule_set rule_set_id
    TDBQRY.new(rules).tap do |q|
      q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
    end.search
  end

  def select_by_prefix prefix, rule_set_id = nil
    TDBQRY.new(rules).tap do |q|
      q.addcond('prefix', TDBQRY::QCSTREQ, prefix.empty? ? nil : prefix)
      if rule_set_id
        q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      end
    end.search
  end

  def select_by_suffix suffix, rule_set_id = nil
    TDBQRY.new(rules).tap do |q|
      q.addcond('suffix', TDBQRY::QCSTREQ, suffix.empty? ? nil : suffix)
      if rule_set_id
        q.addcond('rule_set_id', TDBQRY::QCNUMEQ, rule_set_id)
      end
    end.search
  end

  protected
    def rules
      @rules ||= base.storages[:rules]
    end
end
