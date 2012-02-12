# encoding: utf-8

class Myaso::ActiveRecord
  include Myaso::Client
end

require 'myaso/active_record/prefix'
require 'myaso/active_record/rule'
require 'myaso/active_record/stem'
require 'myaso/active_record/word'
