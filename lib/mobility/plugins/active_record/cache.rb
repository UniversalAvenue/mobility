# frozen-string-literal: true

module Mobility
  module Plugins
    module ActiveRecord
      module Cache
        extend Plugin

        depends_on :active_record, include: false
        depends_on :cache, include: false

        included_hook do |klass, _|
          if options[:cache] && active_record_class?(klass)
            mod = self
            klass.include(Module.new do
              %i[changes_applied clear_changes_information reload].each do |method_name|
                priv = klass.private_method_defined?(method_name)
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

    register_plugin(:active_record_cache, ActiveRecord::Cache)
  end
end
