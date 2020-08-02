# frozen-string-literal: true
require "mobility/plugins/active_model/cache"

module Mobility
  module Plugins
    module ActiveRecord
      module Cache
        extend Plugin

        depends_on :active_record, include: false
        depends_on :active_model_cache, include: :before

        private

        def dirty_reset_methods
          super + %i[reload]
        end
      end
    end

    register_plugin(:active_record_cache, ActiveRecord::Cache)
  end
end
