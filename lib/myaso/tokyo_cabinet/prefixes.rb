# encoding: utf-8

class Myaso::TokyoCabinet::Prefixes < Myaso::Base::Adapter
  include TokyoCabinet

  def find id
    prefixes.get(id)
  end

  def set id, prefix
    prefixes.put(id, prefix)
  end

  def delete id
    prefixes.out(id)
  end

  protected
    def prefixes
      @prefixes ||= base.storages[:prefixes]
    end
end
