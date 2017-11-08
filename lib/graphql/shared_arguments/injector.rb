module GraphQL
  class SharedArguments
    class Injector
      def initialize(object_definition, filter, new_arguments)
        @object_fields = object_definition.fields
        @filter_type = filter.keys.first
        @filter_fields = filter.values.first
        @new_arguments = new_arguments
      end

      def only
        object_fields.select { |k, _v| filter_fields.include?(k.to_sym) }
      end

      def except
        object_fields.reject { |k, _v| filter_fields.include?(k.to_sym) }
      end

      def inject
        @selected_fields = object_fields if filter_fields.nil? && filter_type.nil?
        @selected_fields ||= send(filter_type)

        selected_fields.transform_values do |field|
          field.arguments.merge!(new_arguments)
        end

        object_fields.merge!(selected_fields)
      end

      private

      attr_reader :object_fields, :selected_fields,
                  :filter_type, :filter_fields, :new_arguments
    end
  end
end
