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
  class << self
    def create_fixtures!
      Dir[File.expand_path('*.yml', fixtures_path)].each do |filename|
        create_fixture_for filename
      end
    end

    def create_fixture_for filename
      const_set const_name(filename), YAML.load_file(filename)
    end

    private
      def const_name(filename)
        File.basename(filename, '.*').upcase
      end

      def fixtures_path
        File.expand_path('../../fixtures', __FILE__)
      end
  end

  create_fixtures!
end
