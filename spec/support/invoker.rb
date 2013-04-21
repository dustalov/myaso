# encoding: utf-8

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
    executable = File.expand_path('../../../bin/myaso', __FILE__)
    arguments = argv.map { |s| (s.include? ' ') ? '"%s"' % s : s }.join ' '
    invoke_cache[argv] = `#{executable} #{arguments}`.split(/\n/)
  end
end
