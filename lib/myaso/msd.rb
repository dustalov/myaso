# encoding: utf-8

# The Myaso MSD (morphosyntactic descriptor) model.
#
# This representation, with the concrete applications which
# display and exemplify the attributes and values and provide
# their internal constraints and relationships, makes the proposal
# self-explanatory. Other groups can easily test the
# specifications on their language, simply by following the method of
# the applications. The possibility of incorporating idiosyncratic
# classes and distinctions after the common core features makes the
# proposal relatively adaptable and flexible, without compromising
# compatibility.
#
# MSD implementation and documentation are based on MULTEXT-East
# Morphosyntactic Specifications, Version 4:
# http://nl.ijs.si/ME/V4/msd/html/msd.html
#
# You may use Myaso::MSD either as parser and generator.
#
# ```ruby
# msd = Myaso::MSD.new(Myaso::MSD::Russian)
# msd[:pos] = :noun
# msd[:type] = :common
# msd[:number] = :plural
# msd[:case] = :locative
# msd.to_s # => "Nc-pl"
# ```
#
# ```ruby
# msd = Myaso::MSD.new(Myaso::MSD::Russian, 'Vmps-snpfel')
# msd[:pos] # => :verb
# msd[:tense] # => :past
# msd[:person] # => nil
# msd.grammemes # => {:type=>:main, :vform=>:participle, ...}
# ```
#
class Myaso::MSD
  # Empty descriptor character.
  #
  EMPTY_DESCRIPTOR = '-'

  # An exception that is raised when Myaso::MSD unable to
  # operate with given morphosyntactic descriptor. Mostly
  # this problem is caused by inappropriate language selection
  # or just typos.
  #
  class InvalidDescriptor < RuntimeError; end

  attr_reader :pos, :grammemes, :language

  # Creates a new morphosyntactic descriptor model instance.
  # Please specify a `language` module with defined
  # `CATEGORIES`.
  #
  # Optionally, you can parse MSD string that is passed as
  # `msd` argument.
  #
  # @param language [Myaso::MSD::Language] a language to use.
  # @param msd [String] a String to initialize new MSD.
  #
  def initialize(language, msd = '')
    @language, @pos, @grammemes = language, nil, {}

    unless language.const_defined? 'CATEGORIES'
      raise ArgumentError,
        'given language has no morphosyntactic descriptions'
    end

    parse! msd if msd && !msd.empty?
  end

  # Retrieves the morphosyntactic descriptor corresponding
  # to the `key` object. If not, returns `nil`.
  #
  # @param key [Symbol] a key to look at.
  # @return [Symbol] a value of `key`.
  #
  def [] key
    return pos if :pos == key
    grammemes[key]
  end

  # Assignes the morphosyntactic descriptor given by
  # `value` with the key given by `key` object.
  #
  # @param key [Symbol] a key to be set.
  # @param value [Symbol] a value to be assigned.
  # @return [Symbol] the assigned value.
  #
  def []= key, value
    return @pos = value if :pos == key
    grammemes[key] = value
  end

  # @private
  def inspect
    '#<%s:0x%x msd=%s>' % [language.name, object_id * 2, to_s.inspect]
  end

  # Generates Regexp from the MSD that is useful to perform
  # database queries.
  #
  # ```ruby
  # msd = Myaso::MSD.new(Myaso::MSD::Russian, 'Vm')
  # r = msd.to_regexp # => /^Vm.*$/
  # 'Vmp' =~ r # 0
  # 'Nc-pl' =~ r # nil
  # ```
  #
  # @return [Regexp] the correspondent regular expression.
  #
  def to_regexp
    Regexp.new([
      '^',
      self.to_s.gsub(EMPTY_DESCRIPTOR, '.'),
      '.*',
      '$'
    ].join)
  end

  # Merges grammemes that are stored in `hash` into the
  # MSD grammemes.
  #
  # @param hash [Hash<Symbol, Symbol>] a hash to be processed.
  # @return [MSD] self.
  #
  def merge! hash
    hash.each do |key, value|
      self[key.to_sym] = value.to_sym
    end

    self
  end

  # @private
  def to_s
    return '' unless pos

    unless category = language::CATEGORIES[pos]
      raise InvalidDescriptor, "category is nil"
    end

    msd = [category[:code]]

    attrs = category[:attrs]
    grammemes.each do |attr_name, value|
      next unless value

      attr_index = attrs.index { |name, *values| name == attr_name }
      unless attr_index
        raise InvalidDescriptor, "no such attribute: '#{attr_name}' " \
                                 "of category '#{pos}'"
      end

      attr_name, values = attrs[attr_index]

      unless attr_value = values[value]
        raise InvalidDescriptor, "no such value: '#{value}'' " \
                                 "for attribute '#{attr_name}' " \
                                 "of category '#{pos}'"
      end

      msd[attr_index + 1] = attr_value
    end

    msd.map { |e| e || EMPTY_DESCRIPTOR }.join
  end

  # Validates the MSD instance.
  #
  # @return [true, false] validation state of the MSD instance.
  #
  def valid?
    !!to_s
  rescue InvalidDescriptor
    false
  end

  protected
    # @private
    def parse! msd_line
      msd = msd_line.chars.to_a

      category_code = msd.shift

      @pos, category = language::CATEGORIES.find do |name, category|
        category[:code] == category_code
      end

      raise InvalidDescriptor, msd_line unless @pos

      attrs = category[:attrs]

      msd.each_with_index do |value_code, i|
        attr_name, values = attrs[i]
        raise InvalidDescriptor, msd_line unless attr_name

        next if :blank == attr_name
        next if EMPTY_DESCRIPTOR == value_code

        attribute = values.find { |name, code| code == value_code }
        raise InvalidDescriptor, msd_line unless attribute

        self[attr_name] = attribute.first
      end
    end
end
