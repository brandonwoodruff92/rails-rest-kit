module RailsRestKit
  class Permitter
    attr_reader :configurations

    def initialize
      @configurations = {}
    end

    # Configure permitted attributes for a resource
    def configure(resource_name, &block)
      configurations[resource_name.to_s] = Configuration.new(&block)
    end

    # Get configuration for a specific resource
    def for(resource_name)
      configurations[resource_name.to_s]
    end

    # Permit parameters for a specific resource
    def permit(resource_name, params)
      config = for(resource_name)
      raise ArgumentError, "No configuration found for resource: #{resource_name}" unless config
      
      config.permit(params)
    end

    # Configuration class for each resource
    class Configuration
      attr_reader :attributes, :nested_attributes, :collections

      def initialize(&block)
        @attributes = []
        @nested_attributes = {}
        @collections = {}
        instance_eval(&block) if block_given?
      end

      # Specify required top-level keys
      def require(*keys)
        @required_keys.concat(keys.map(&:to_s))
      end

      # Specify expected top-level keys
      def expect(*keys)
        @expected_keys.concat(keys.map(&:to_s))
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
        filtered = params

        # Apply require and expect to params
        @required_keys.each { |key| filtered = filtered.require(key) }
        @expected_keys.each { |key| filtered = filtered.expect(key) }

        permitted = filtered.permit(@attributes)

        # Handle nested attributes
        @nested_attributes.each do |nested_name, nested_config|
          if filtered[nested_name].present?
            permitted[nested_name] = nested_config.permit(filtered[nested_name])
          end
        end

        # Handle collection attributes
        @collections.each do |collection_name, collection_config|
          if filtered[collection_name].present?
            permitted[collection_name] = filtered[collection_name].map do |item|
              collection_config.permit(item)
            end
          end
        end

        permitted
      end
    end
  end
end