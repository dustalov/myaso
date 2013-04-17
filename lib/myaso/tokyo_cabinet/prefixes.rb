# encoding: utf-8

# @private
class Myaso::TokyoCabinet::Prefixes
  attr_reader :base
  protected :base

  def initialize base
    @base = base
  end

  def find id
    return unless prefix = prefixes.get(id)
    values = prefix.values_at('prefix')
    Myaso::Prefix.new(id.to_i, *values)
  end

  def set prefix, id = nil
    prefixes.put(id || prefix.id, prefix.to_h.tap { |r| r.delete('id') })
  end

  def delete id
    prefixes.out(id)
  end

  def size
    prefixes.size
  end

  protected
    def prefixes
      @prefixes ||= base.storages[:prefixes]
    end
end
