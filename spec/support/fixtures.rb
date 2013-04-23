# encoding: utf-8

require 'yaml'

# When this file is loaded, for each fixture file, a singleton method is
# created within the Myaso::Fixtures module with the same name as the fixture
# file, returning the value of the fixture.
#
# For example, file <tt>prefixes.yml</tt>:
#
#   - id: 1
#     prefix: sub
#   - id: 2
#     prefix: bi
#
# These fixtures would be made available like so:
#
#   Myaso::Fixtures::PREFIXES
#   => [{"id"=>1, "prefix"=>"sub"}, {"id"=>2, "prefix"=>"bi"}]
#
# You can find out all available fixtures by calling
#
#   Myaso::Fixtures.constants
#   => [ :BUCKETS ]
#
module Myaso::Fixtures
end

fixtures_path = File.expand_path('../../fixtures', __FILE__)

Dir[File.expand_path('*.yml', fixtures_path)].each do |filename|
  const_name = File.basename(filename, '.*').upcase
  Myaso::Fixtures.const_set(const_name, YAML.load_file(filename))
end
