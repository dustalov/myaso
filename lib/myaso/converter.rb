# encoding: utf-8

class Myaso
  class Converter
    require 'iconv'
    require 'tempfile'

    attr_reader :tch_path, :morphs, :gramtab, :encoding

    # Create new <tt>Myaso::Converter</tt> with defined
    # result <tt>tch_path</tt> and <tt>options</tt>
    # from <tt>Myaso::CLI</tt>.
    def initialize(tch_path, morphs, gramtab, options)
      @tch_path, @morphs, @gramtab, @encoding =
        tch_path, morphs, gramtab, options[:encoding]
    end

    # Convert the http://aot.ru dictonaries to
    # <tt>myaso</tt>-compatible format (TokyoCabinet Hash).
    def perform!
      store # just initialize TC

      # load morphs
      puts "Processing '#{morphs}'..."
      to_tempfile(morphs).tap do |file|
        puts '  Loading rules...'
        load_rules(file)
        puts '  Loading lemmas...'
        load_lemmas(file)
        puts '  Loading prefixes...'
        load_prefixes(file)
      end.close!
      puts "Done."

      # load gramtab
      puts "Processing '#{gramtab}'..."
      to_tempfile(gramtab).tap do |file|
        load_gramtab(file)
      end.close!
      puts "Done."

      store.close
    end

    private
    # Convert the content of file <tt>source_filename</tt> into
    # the defined <tt>encoding</tt> (using <tt>Iconv</tt>) and
    # save as <tt>Tempfile</tt>.
    def to_tempfile(source_filename)
      Tempfile.new('myaso').tap do |temp|
        Iconv.open('utf-8', @encoding) do |cd|
          IO.foreach(source_filename).each do |line|
            temp.puts cd.iconv(line)
          end
        end
        temp.rewind
      end
    end

    # Implement <tt>each_with_index</tt> according to <tt>mrd</tt>
    # file structure with <tt>morphs_file</tt> processing,
    # like “ё” (YO) letter replacing with “е” letter (YE).
    def morphs_foreach(morphs_file, &block)
      morphs_file.rewind
      morphs_file.readline.to_i.times do |i|
        line = morphs_file.readline
        line.mb_chars.gsub!('Ё', 'Е')
        block.call(line.strip, i)
      end
    end

    # Parse the <tt>morphs_file</tt> and load it as words paradigm.
    def load_rules(file)
      morphs_foreach(file) do |line, index|
        line.split('%').each do |rule|
          if rule && !rule.empty?
            parts = rule.split '*'
            parts << '' while parts.size < 3
            parts[1].mb_chars.slice! 0..2

            rule = store["rules-#{index}"] || []
            rule << parts
            store["rules-#{index}"] = parts
          end
        end
      end
    end

    # Parse the <tt>morphs_file</tt> and load it as lemmas section.
    def load_lemmas(file)
      morphs_foreach(file) do |line, index|
        base, rule_id = line.split

        lemmas = store["lemmas-#{base}"] || []
        lemmas << rule_id.to_i
        store["lemmas-#{base}"] = lemmas

        freq = store["rulefreq-#{rule_id}"] || 0
        store["rulefreq-#{rule_id}"] = freq + 1
      end
    end

    # Parse the <tt>morphs_file</tt> and load it as prefixes section.
    def load_prefixes(file)
      prefixes = []
      morphs_foreach(file) do |line, index|
        prefixes << line
        store["prefixes-#{index}"] = line
      end
    end

    # Parse the <tt>gramtab_file</tt> and retrieve the grammatic forms.
    def load_gramtab(gramtab_file)
      gramtab_file.each do |line|
        line.strip!
        unless line.empty? || line.start_with?('//')
          gram = line.split
          gram << '' while gram.size < 4
          ancode, letter, type, info = gram
          store["gramtab-#{ancode}"] = [ letter, type, info ]
        end
      end
    end

    protected
    # Caching accessor to the TokyoCabinet Hash.
    def store
      @store ||= TokyoCabinet::HDB.new.tap do |hdb|
        hdb.open(tch_path)
      end
    end
  end
end
