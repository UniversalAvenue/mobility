# frozen_string_literal: true

module Mobility
=begin

Stores shared Mobility configuration referenced by all backends.

=end
  class Configuration
    # Alias for mobility_accessor (defaults to +translates+)
    # @return [Symbol]
    attr_accessor :accessor_method

    # Name of query scope/dataset method (defaults to +i18n+)
    # @return [Symbol]
    attr_accessor :query_method

    # @param [Symbol] name Plugin name
    def plugin(name, **options)
      attributes_class.plugin(name, **options)
    end

    def default(name, value)
      attributes_class.default(name, value)
    end

    # @param [Symbol] name Plugin name
    def plugins(*names)
      names.each { |name| attributes_class.plugin name }
    end

    # Generate new fallbacks instance
    # @note This method will call the proc defined in the variable set by the
    # +fallbacks_generator=+ setter, passing the first argument to its `call`
    # method. By default the generator returns an instance of
    # +I18n::Locale::Fallbacks+.
    # @param fallbacks [Hash] Fallbacks hash passed to generator
    # @return [I18n::Locale::Fallbacks]
    def new_fallbacks(fallbacks = {})
      @fallbacks_generator.call(fallbacks)
    end

    # Assign proc which, passed a set of fallbacks, returns a default fallbacks
    # instance. By default this is a proc which takes fallbacks and returns an
    # instance of +I18n::Locale::Fallbacks+.
    # @param [Proc] fallbacks generator
    attr_writer :fallbacks_generator

    # Default backend to use (can be symbol or actual backend class)
    # @return [Symbol,Class]
    def default_backend
      attributes_class.defaults[:backend]
    end

    # Returns set of default accessor locales to use (defaults to
    # +I18n.available_locales+)
    # @return [Array<Symbol>]
    def default_accessor_locales
      if @default_accessor_locales.is_a?(Proc)
        @default_accessor_locales.call
      else
        @default_accessor_locales
      end
    end
    attr_writer :default_accessor_locales

    def initialize
      @accessor_method = :translates
      @query_method = :i18n
      @fallbacks_generator = lambda { |fallbacks| Mobility::Fallbacks.build(fallbacks) }
      @default_accessor_locales = lambda { Mobility.available_locales }
    end

    def attributes_class
      @attributes_class ||= Class.new(Attributes)
    end
  end
end
