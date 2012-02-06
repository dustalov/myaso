# encoding: utf-8

# Core of the Myaso library.
#
class Myaso::Base
  class << self
    # Define a new method that will fetch the necessary namespace adapter
    # for current Myaso::Base instance.
    #
    def adapter_for *names
      names.each do |name|
        define_method name do
          ivar_name = '@%s' % name

          ivar = instance_variable_get(ivar_name)
          return ivar if ivar

          class_name = name.to_s.capitalize
          ivar = self.class.const_get(class_name).new(self)
          instance_variable_set(ivar_name, ivar)
        end
      end
    end
  end

  # Create an instance of Myaso::Base class, which is necessary to
  # proper work of the other components of Myaso library.
  #
  def initialize
    if Myaso::Base == self.class
      raise 'You must not instantiate the Myaso::Base class! ' \
            'Try to make instances of its ancestors instead.'
    end
  end

  adapter_for :prefixes, :rules, :stems, :words
end
