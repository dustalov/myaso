# encoding: utf-8

# @private
class Struct
  def to_h
    members.inject({}) { |h, m| h[m.to_s] = self[m] if self[m]; h }
  end
end
