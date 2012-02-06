# encoding: utf-8

if 'rbx' == RUBY_ENGINE
  class Object
    alias_method :public_send, :send
  end
end
