# encoding: utf-8

class Myaso
  class Converter
    require 'iconv'
    require 'tempfile'

    attr_reader :tch_path, :encoding, :morphs, :gramtab

    # Create new <tt>Myaso::Converter</tt> with defined
    # result <tt>tch_path</tt> and <tt>options</tt>
    # from <tt>Myaso::CLI</tt>.
    def initialize(tch_path, options)
      @tch_path, @encoding, @morphs, @gramtab =
        tch_path, options[:encoding], options[:morphs], options[:gramtab]
    end

    # Convert the <a href='http://aot.ru/'>aot.ru</a> dictonaries to
    # <tt>myaso</tt>-compatible format (TokyoTable).
    def perform!
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

    # Parse the <tt>gramtab_file</tt> and retrieve the grammatic forms.
    def load_gramtab(gramtab_file)
      gramtab_file.each do |line|
        line.strip!
        unless line.empty? || line.start_with?('//')
          gram = line.split
          gram << '' while gram.size < 4
          # TODO: store parsed gram
        end
      end
    end
  end
end