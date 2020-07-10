require_relative "./active_model/dirty"
require_relative "./active_model/cache"

module Mobility
  module Plugins
    module ActiveModel
      extend Plugin

      depends_on :active_model_dirty
      depends_on :active_model_cache
      depends_on :backend, include: :before

      private

      def active_model_class?(klass)
        klass.ancestors.include?(::ActiveModel::Dirty)
      end
    end

    register_plugin(:active_model, ActiveModel)
  end
end
