# encoding: utf-8

class Myaso::TokyoCabinet::Prefixes < Myaso::Adapter
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
      @prefixes ||= client.storages[:prefixes]
    end
end
