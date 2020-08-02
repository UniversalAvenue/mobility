# frozen-string-literal: true

module Mobility
  module Plugins
    module ActiveModel
=begin

Adds hooks to clear Mobility cache when AM dirty reset methods are called.

=end
      module Cache
        extend Plugin

        depends_on :cache, include: false

        included_hook do |klass, _|
          if options[:cache]
            mod = self
            private_methods = dirty_reset_methods & klass.private_instance_methods

            dirty_reset_methods.each do |method_name|
              define_method method_name do |*args|
                super(*args).tap do
                  mod.names.each { |name| mobility_backends[name].clear_cache }
                end
              end
            end
            klass.class_eval { private(*private_methods) }
          end
        end

        private

        def dirty_reset_methods
          %i[changes_applied clear_changes_information]
        end
      end
    end

    register_plugin(:active_model_cache, ActiveModel::Cache)
  end
end
