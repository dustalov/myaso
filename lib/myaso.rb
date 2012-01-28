# encoding: utf-8

require 'myaso/version'

module Myaso
end

require 'myaso/base'
require 'myaso/active_record' if defined? ::ActiveRecord::Base
require 'myaso/tokyo_cabinet' if defined? ::TokyoCabinet::TDB
