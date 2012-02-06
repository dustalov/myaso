# encoding: utf-8

class Myaso::TokyoCabinet::Words < Myaso::Base::Adapter
  include TokyoCabinet

  def find id
    base.storages[:words][id]
  end

  def set id, rule
    base.storages[:words][id] = rule
  end

  def delete id
    base.storages[:words].delete id
  end
end
