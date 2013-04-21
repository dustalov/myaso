# encoding: utf-8

require 'open3'

# http://dota2.ru/guides/880-invokirkhakha-sanstrajk-ni-azhydal-da/
#
class MiniTest::Unit::TestCase
  # Quas Wex Exort.
  #
  def invoke_cache
    @invoke_cache ||= {}
  end

  # So begins a new age of knowledge.
  #
  def invoke(*argv)
    return invoke_cache[argv] if invoke_cache.has_key? argv

    arguments = argv.dup
    options = (arguments.last.is_a? Hash) ? arguments.pop : {}
    executable = File.expand_path('../../../bin/myaso', __FILE__)

    Open3.popen3(executable, *arguments) do |i, o, *_|
      i.puts options[:stdin] if options[:stdin]
      i.close
      invoke_cache[argv] = o.readlines.map(&:chomp!)
    end
  end
end
