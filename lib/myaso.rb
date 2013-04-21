# encoding: utf-8

require 'myaso/version'

require 'myasorubka'

require 'myaso/base'

require 'myaso/active_record' if defined? ::ActiveRecord::Base
require 'myaso/tokyo_cabinet' if defined? ::TokyoCabinet::TDB

require 'myaso/core_ext/struct'

# This structure represents a single prefix.
#
class Myaso::Prefix < Struct.new(:id, :prefix)
end

# This structure represents a single stem.
#
class Myaso::Stem < Struct.new(:id, :rule_set_id, :msd, :stem)
end

# This structure represents a single inflection rule.
#
class Myaso::Rule < Struct.new(:id, :rule_set_id, :msd, :prefix, :suffix)
end

# This structure represents a single word.
#
class Myaso::Word < Struct.new(:id, :stem_id, :rule_id)
end

require 'myaso/analyzer'
require 'myaso/tagger'
