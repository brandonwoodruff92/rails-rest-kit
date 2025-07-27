module RailsRestKit
  class Permitter
    attr_reader :configurations

    def initialize
      @configurations = {}
    end

    # Configure permitted attributes for a resource
    def configure(resource_name, required: false, &block)
      configurations[resource_name.to_s] = Configuration.new(required: required, &block)
    end

    # Get configuration for a specific resource
    def for(resource_name)
      configurations[resource_name.to_s]
    end

    # Permit parameters for a specific resource
    def permit(resource_name, params)
      config = self.for(resource_name)
      raise ArgumentError, "No configuration found for resource: #{resource_name}" unless config
      if config.required
        resource_params = params.require(resource_name)
      else
        resource_params = params[resource_name] || params
      end
      config.permit(resource_params)
    end

    # Configuration class for each resource
    class Configuration
      attr_reader :attributes, :nested_attributes, :collections, :required

      def initialize(required: false, &block)
        @attributes = []
        @nested_attributes = {}
        @collections = {}
        @required = required
        instance_eval(&block) if block_given?
      end

      # Define basic attributes
      def attributes(*attrs)
        @attributes.concat(attrs.map(&:to_s))
      end

      # Define nested attributes
      def nested(name, &block)
        @nested_attributes[name.to_s] = Configuration.new(&block)
      end

      # Define collection attributes
      def collection(name, &block)
        @collections[name.to_s] = Configuration.new(&block)
      end

      # Permit parameters based on configuration
      def permit(params)
        permitted = params.permit(@attributes)

        # Handle nested attributes
        @nested_attributes.each do |nested_name, nested_config|
          if params[nested_name].present?
            permitted[nested_name] = nested_config.permit(params[nested_name])
          end
        end

        # Handle collection attributes
        @collections.each do |collection_name, collection_config|
          if params[collection_name].present?
            permitted[collection_name] = params[collection_name].map do |item|
              collection_config.permit(item)
            end
          end
        end

        permitted
      end
    end
  end
end