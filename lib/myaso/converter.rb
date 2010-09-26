# encoding: utf-8

class Myaso
  class Converter
    require 'iconv'
    require 'tempfile'
    require 'sqlite3'
    require 'sequel'

    attr_reader :storage_path, :morphs, :gramtab, :encoding
    attr_reader :sequel

    # Create new <tt>Myaso::Converter</tt> with defined
    # result path in <tt>storage_path</tt> and following
    # <tt>options</tt> from <tt>Myaso::CLI</tt>.
    def initialize(storage_path, morphs, gramtab, options)
      @storage_path, @morphs, @gramtab, @encoding =
        storage_path, morphs, gramtab, options[:encoding]
      @sequel = Sequel.connect(storage_path)
    end

    # Convert the http://aot.ru dictonaries to
    # <tt>myaso</tt>-eatable format.
    def perform!
      # load morphs
      puts "Processing '#{morphs}'..."
      to_tempfile(morphs).tap do |file|
        file.rewind

        print '  Loading rules... '
        load_rules(file)

        print '  Passing accents... '
        morphs_foreach(file)

        print '  Passing logs... '
        morphs_foreach(file)

        print '  Loading prefixes... '
        load_prefixes(file)

        print '  Loading lemmas... '
        load_lemmas(file)
      end.close!
      puts "Done."

      # load gramtab
      puts "Processing '#{gramtab}'..."
      to_tempfile(gramtab).tap do |file|
        load_gramtab(file)
      end.close!
      puts "Done."
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
      index = morphs_file.readline.to_i.times do |i|
        line = morphs_file.readline
        next unless block
        line.mb_chars.gsub!('Ё', 'Е')
        block.call(line.strip, i)

        if i % 50 == 0
          STDOUT.print i
          STDOUT.print ' '
          STDOUT.flush
        end
      end

      STDOUT.print index unless index % 50 == 0
      STDOUT.puts
    end

    # Parse the <tt>morphs_file</tt> and load it as words paradigm.
    def load_rules(file)
      morphs_foreach(file) do |line, index|
        sequel.transaction do
          line.split('%').each do |rule|
            if rule && !rule.empty?
              parts = rule.split '*'
              parts << '' while parts.size < 3
              parts[1].mb_chars.slice! 0..2

              rule = Model::Rule.create(:rule_id => index,
                :suffix => parts[0], :ancode => parts[1],
                :prefix => parts[2])
            end
          end
        end
      end
    end

    # Parse the <tt>morphs_file</tt> and load it as lemmas section.
    def load_lemmas(file)
      morphs_foreach(file) do |line, index|
        sequel.transaction do
          record = line.split
          base, rule_id = record[0], record[1].to_i

          rule = Model::Rule.find(:rule_id => rule_id)
          rule.update :freq => rule.freq + 1

          lemma = Model::Lemma.create(:rule_id => rule_id,
            :base => base)
          rule.add_lemma(lemma)
        end
      end
    end

    # Parse the <tt>morphs_file</tt> and load it as prefixes section.
    def load_prefixes(file)
      morphs_foreach(file) do |line, index|
        sequel.transaction do
          prefix = Model::Prefix.create(:line => line)
        end
      end
    end

    # Parse the <tt>gramtab_file</tt> and retrieve the grammatic forms.
    def load_gramtab(gramtab_file)
      gramtab_file.each do |line|
        line.strip!
        sequel.transaction do
          unless line.empty? || line.start_with?('//')
            gram = line.split
            gram << '' while gram.size < 4
            ancode, letter, type, info = gram

            gramtab = Model::Gramtab.create(:ancode => ancode,
              :letter => letter, :kind => type, :info => info)
          end
        end
      end
    end

    # Discover endings from known <tt>rules</tt> and
    # <tt>lemmas</tt>.
    def discover_endings()
      sequel.transaction do
        Model::Lemma.each do |lemma|
          lemma.rules.each do |rule|
            word = [ rule.prefix, lemma.base, rule.suffix ].join
            (1..5).each do |i|
              next unless word_end = word.mb_chars[-i..-1]
              # Model::Ending.create(:rule_id => rule.rule_id,
              #   :word_end => word_end, :index => rule.id)
            end
          end
        end
      end
    end

    # Cleanup the known endings list.
    def cleanup_endings
      Model::Ending.each do |ending|
      end
    end
    end
  end
end
