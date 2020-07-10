module Mobility
  module Plugins
=begin

Adds translated attribute names and values to the hash returned by #attributes.
Also adds a method #translated_attributes with names and values of translated
attributes only.

@note Adding translated attributes to +attributes+ can have unexpected
  consequences, since these attributes do not have corresponding columns in the
  model table. Using this plugin may lead to conflicts with other gems.

=end
    module AttributeMethods
      extend Plugin

      depends_on :active_record, include: false

      # Applies attribute_methods plugin for a given option value.
      included_hook do |model_class|
        if options[:attribute_methods]
          include_attribute_methods_module(model_class, *names)
        end
      end

      private

      def include_attribute_methods_module(model_class, *attribute_names)
        if model_class.ancestors.include?(::ActiveRecord::AttributeMethods)
          require "mobility/plugins/active_record/attribute_methods_builder"
          model_class.include Plugins::ActiveRecord::AttributeMethodsBuilder.new(*attribute_names)
        end
      end
    end

    register_plugin(:attribute_methods, AttributeMethods)
  end
end
