class Myaso
  require 'thor'

  class CLI < Thor
    namespace :myaso

    desc 'convert DICT_PATH', 'Convert aot.ru dictonaries into the TokyoCabinet'
    def convert(dict_path)
      
    end

    desc 'version', 'Print the myaso version'
    def version
      puts [ 'myaso', 'version', Myaso.version ].join(' ')
    end
  end
end
