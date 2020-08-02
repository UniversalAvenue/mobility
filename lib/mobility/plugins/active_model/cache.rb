# frozen-string-literal: true

module Mobility
  module Plugins
    module ActiveModel
      module Cache
        extend Plugin

        depends_on :active_model_dirty, include: false
        depends_on :cache, include: false

        initialize_hook do
          if options[:cache]
            mod = self
            cache_methods.each do |method_name|
              define_method method_name do |*args|
                super(*args).tap do
                  mod.names.each { |name| mobility_backends[name].clear_cache }
                end
              end
            end
          end
        end

        included_hook do |klass, _|
          if options[:cache]
            cache_methods.each do |method_name|
              private method_name if klass.private_method_defined?(method_name)
            end
          end
        end

        private

        def cache_methods
          %w[changes_applied clear_changes_information]
        end
      end
    end

    register_plugin(:active_model_cache, ActiveModel::Cache)
  end
end
