# encoding: utf-8

class Myaso::TokyoCabinet::Words < Myaso::Base::Adapter
  include TokyoCabinet

  def find id
    words[id]
  end

  def set id, rule
    words[id] = rule
  end

  def delete id
    words.delete id
  end

  protected
    def words
      @words ||= base.storages[:words]
    end
end
