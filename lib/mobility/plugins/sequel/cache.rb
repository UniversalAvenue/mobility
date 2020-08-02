# frozen-string-literal: true

module Mobility
  module Plugins
    module Sequel
=begin

Adds hook to clear Mobility cache when +refresh+ is called on Sequel model.

=end
      module Cache
        extend Plugin

        depends_on :sequel, include: false
        depends_on :cache, include: false

        initialize_hook do
          if options[:cache]
            mod = self
            define_method :refresh do |*args|
              super(*args).tap do
                mod.names.each { |name| mobility_backends[name].clear_cache }
              end
            end
          end
        end
      end
    end

    register_plugin(:sequel_cache, Sequel::Cache)
  end
end
