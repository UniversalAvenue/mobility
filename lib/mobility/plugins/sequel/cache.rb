# frozen-string-literal: true

module Mobility
  module Plugins
    module Sequel
      module Cache
        extend Plugin

        depends_on :sequel, include: false
        depends_on :cache, include: false

        included_hook do |klass, _|
          if options[:cache]
            mod = self
            klass.include(Module.new do
              %i[refresh].each do |method_name|
                priv = klass.private_method_defined?(:refresh)
                define_method method_name do |*args|
                  super(*args).tap do
                    mod.names.each do |name|
                      mobility_backends[name].clear_cache
                    end
                  end
                end
                private method_name if priv
              end
            end)
          end
        end
      end
    end

    register_plugin(:sequel_cache, Sequel::Cache)
  end
end
