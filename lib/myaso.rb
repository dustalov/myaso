# encoding: utf-8

require 'myaso/version'

require 'myaso/msd'

require 'myaso/base'
require 'myaso/adapter'

require 'myaso/active_record' if defined? ::ActiveRecord::Base
require 'myaso/tokyo_cabinet' if defined? ::TokyoCabinet::TDB

require 'myaso/analyzer'
