require "sequel"
raise VersionNotSupportedError, "Mobility is only compatible with Sequel 4.0 and greater" if ::Sequel::MAJOR < 4
require "sequel/plugins/mobility"
unless defined?(ActiveSupport::Inflector)
  # TODO: avoid automatically including the inflector extension
  require "sequel/extensions/inflector"
end
require "sequel/plugins/dirty"
require_relative "./sequel/backend"
require_relative "./sequel/dirty"
require_relative "./sequel/cache"
require_relative "./sequel/query"

module Mobility
  module Plugins
    module Sequel
      extend Plugin

      depends_on :sequel_backend, include: :after
      depends_on :sequel_dirty
      depends_on :sequel_cache
      depends_on :sequel_query

      private

      def sequel_class?(klass)
        klass < ::Sequel::Model
      end
    end

    register_plugin(:sequel, Sequel)
  end
end
