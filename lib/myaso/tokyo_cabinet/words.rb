# encoding: utf-8

class Myaso::TokyoCabinet::Words < Myaso::Adapter
  def find id
    words.get(id)
  end

  def set id, rule
    words.put(id, rule)
  end

  def delete id
    words.delete(id)
  end

  protected
    def words
      @words ||= client.storages[:words]
    end
end
