# encoding: utf-8

# Client of the Myaso::Adapter instances.
#
module Myaso::Client
  class << self
    # Define a new method that will fetch the necessary adapter for the
    # current Myaso::Client mixed-in class.
    #
    # @param names [Array<Symbol>] an array of adapter names.
    # @return [Adapter] an adapter instance.
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

  adapter_for :prefixes, :rules, :stems, :words
end
