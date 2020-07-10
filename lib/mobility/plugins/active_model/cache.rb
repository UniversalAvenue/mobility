# frozen-string-literal: true

module Mobility
  module Plugins
    module ActiveModel
      module Cache
        extend Plugin

        depends_on :active_model, include: false
        depends_on :cache, include: false

        included_hook do |klass, _|
          if options[:cache] && active_model_class?(klass)
            mod = self

            klass.class_eval do
              %i[changes_applied clear_changes_information].each do |method_name|
                priv = klass.private_method_defined?(method_name)
                define_method method_name do |*args|
                  super(*args).tap do
                    mod.names.each { |name| mobility_backends[name].clear_cache }
                  end
                end
                private method_name if priv
              end
            end
          end
        end
      end
    end

    register_plugin(:active_model_cache, ActiveModel::Cache)
  end
end
