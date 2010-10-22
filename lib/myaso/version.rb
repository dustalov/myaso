class Myaso
  # Myaso version information.
  # Using Semantic Version (http://semver.org/) specification.
  class Version
    class << self
      # Root path of the Myaso gem.
      #
      # ==== Returns
      # String:: Myaso gem root path.
      #
      def root
        @@myaso_root ||= File.expand_path('../../../', __FILE__)
      end

      # Myaso gem version according to VERSION file.
      #
      # ==== Returns
      # String:: Myaso semantic version.
      #
      def to_s
        @@version ||= File.read(File.join(Myaso::Version.root, 'VERSION')).chomp
      end
    end
  end
end
