module Myaso # :nodoc:
  # Myaso version information.
  # Using Semantic Version (http://semver.org/) specification.
  #
  module Version
    class << self
      # Myaso major version.
      #
      MAJOR = 0

      # Myaso minor version.
      #
      MINOR = 2

      # Myaso patch version.
      #
      PATCH = 0

      # Myaso gem version according to VERSION file.
      #
      # ==== Returns
      # String:: Myaso semantic version.
      #
      def to_s
        @@version ||= [ MAJOR, MINOR, PATCH ] * '.'
      end
    end
  end
end
