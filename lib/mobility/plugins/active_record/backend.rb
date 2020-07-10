module Mobility
  module Plugins
    module ActiveRecord
      module Backend
        extend Plugin

        depends_on :backend, include: :before
        depends_on :active_record, include: false

        def load_backend(backend, klass:)
          if Symbol === backend && active_record_class?(klass)
            require "mobility/backends/active_record/#{backend}"
            Backends.load_backend("active_record_#{backend}".to_sym)
          else
            super
          end
        end
      end
    end

    register_plugin(:active_record_backend, ActiveRecord::Backend)
  end
end
