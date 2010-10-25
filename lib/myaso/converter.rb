# encoding: utf-8

# Converter of http://aot.ru/ dictonaries to the storage
# eatable by Myaso.
#
class Myaso::Converter
  require 'iconv'
  require 'tempfile'

  attr_reader :storage_path, :store, :morphs, :gramtab, :encoding
  private :storage_path, :store

  # Create a new instance of the Myaso::Converter class.
  #
  # ==== Parameters
  # storage_path<String>:: Root directory of Myaso store.
  #
  # morphs<String>:: Relative path to the morphs.mrd file, which contains the
  #                  rules, lemmas and other prefixes information.
  #
  # gramtab<String>:: Relative path to the gramtab file, which contains the
  #                   importain grammatic information necessary to
  #                   prediction.
  #
  # options<Hash>:: Configuration for this Myaso::Converter class.
  #
  def initialize(storage_path, morphs, gramtab, options)
    @storage_path, @morphs, @gramtab, @encoding =
      storage_path, morphs, gramtab, options[:encoding]
    @store = Myaso::Store.new(storage_path)
  end

  # Perform the conversion of initialized dictionaries to
  # the storage, compatible with Myaso.
  #
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

    nil
  end

  private
  # Convert the content of source file of the defined encoding
  # and save as temporary file in UTF-8 charset.
  #
  # ==== Parameters
  # source_filename<String>:: Source file name.
  #
  # ==== Returns
  # Tempfile:: Recoded and prepared temporary file.
  #
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

  # Implementation of Array#each_with_index method but according
  # to the morphs.mrd file structure while processing. Also this
  # method replaces “ё” (YO) letter with “е” letter (YE)
  # on fly.
  #
  # ==== Parameters
  # morphs_file<String>:: Relative path to the morphs.mrd file.
  # block<Proc>:: Handler of another morphs.mrd section.
  #
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

    nil
  end

  # Parse the another morphs.mrd section as rules and store
  # them into the database.
  #
  # ==== Parameters
  # file<File>:: Opened morphs.mrd file.
  #
  def load_rules(file)
    morphs_foreach(file) do |line, index|
      flexia = store.flexias[index] || Myaso::Model::Flexia.new
      flexia.freq ||= 0
      flexia.forms ||= []

      line.split('%').each do |rule|
        next unless rule && !rule.empty?

        parts = rule.split '*'
        parts << '' while parts.size < 3
        parts[1].mb_chars.slice! 0..2
        # [ suffix, ancode, prefix ]

        form = Myaso::Model::Flexia::Form.new
        form.ancode = parts[1]
        form.prefix = parts[2]
        form.suffix = parts[0]

        flexia.forms << form
      end

      store.flexias[index] = flexia
    end
  end

  # Parse the another morphs.mrd section as lemmas and store
  # them into the database.
  #
  # ==== Parameters
  # file<File>:: Opened morphs.mrd file.
  #
  def load_lemmas(file)
    morphs_foreach(file) do |line, *index|
      record = line.split
      base, flexia_id = record[0], record[1].to_i

      lemma = Myaso::Model::Lemma.new
      lemma.flexia_id = flexia_id
      store.lemmas[base] = lemma

      flexia = store.flexias[flexia_id]
      flexia.freq += 1
      store.flexias[flexia_id] = flexia
    end
  end

  # Parse the another morphs.mrd section as prefixes and store
  # them into the database.
  #
  # ==== Parameters
  # file<File>:: Opened morphs.mrd file.
  #
  def load_prefixes(file)
    prefixes = []
    morphs_foreach(file) do |line, *index|
      prefixes << line
    end
    store.prefixes['prefixes'] = prefixes
  end

  # Parse the gramtab file and retrieve the grammatic forms
  # information.
  #
  # ==== Parameters
  # gramtab_file<File>:: Opened gramtab file.
  #
  def load_gramtab(gramtab_file)
    i = 0

    gramtab_file.each do |line|
      line.strip!
      next if line.empty? || line.start_with?('//')

      gram = line.split
      gram << '' while gram.size < 4
      # [ ancode, letter, part, grammems ]

      ancode = Myaso::Model::Ancode.new
      ancode.part = gram[2]
      ancode.grammems = gram[3]

      store.ancodes[gram.first] = ancode

      i += 1
      if i % 50 == 0
        STDOUT.print i
        STDOUT.print ' '
        STDOUT.flush
      end
    end

    STDOUT.print i unless i % 50 == 0
    STDOUT.puts

    nil
  end

  # Discover word endings from known rules and lemmas from
  # database.
  #
  def discover_endings()
    store.lemmas.each do |lemma|
      flexia = store.flexias[lemma.flexia_id]
      flexia.forms.each do |form|
        word = [ form.prefix, lemma, form.suffix ].join
        (1..5).each do |i|
          next unless word_end = word.mb_chars[-i..-1]

          # word = Myaso::Model::Word.new
          # word.ending = word_end
          # words = store.words['words']
          # words << word
          # store.words['words'] = words
        end
      end
    end

    nil
  end

  # Cleanup word endings.
  #
  def cleanup_endings
    #Myaso::Model::Ending.each do |ending|
    #end
  end
end
