module Mobility
  module Plugins
    module Sequel
      module Backend
        extend Plugin

        depends_on :backend, include: :before
        depends_on :sequel, include: false

        def load_backend(backend, klass:)
          if Symbol === backend && klass < ::Sequel::Model
            require "mobility/backends/sequel/#{backend}"
            Backends.load_backend("sequel_#{backend}".to_sym)
          else
            super
          end
        end
      end
    end

    register_plugin(:sequel_backend, Sequel::Backend)
  end
end
