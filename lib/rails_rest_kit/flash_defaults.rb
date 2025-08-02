module RailsRestKit
  class FlashDefaults
    include Singleton

    def create_valid(params = nil)
      default_params = { 
        type: :notice, 
        message: -> (resource) { "#{resource.model_name.human} was successfully created." } 
      }
      if params.nil?
        @default_create_valid ||= Default.new(default_params)
      else
        params.reverse_merge!(default_params)
        @default_create_valid = Default.new(params[:type], params[:message])
      end
    end

    def create_invalid(params = nil)
      default_params = { 
        type: :alert, 
        message: -> (resource) { "#{resource.model_name.human} failed to be created." } 
      }
      if params.nil?
        @default_create_invalid ||= Default.new(default_params)
      else
        params.reverse_merge!(default_params)
        @default_create_invalid = Default.new(params[:type], params[:message])
      end
    end

    def update_valid(params = nil)
      default_params = { 
        type: :notice, 
        message: -> (resource) { "#{resource.model_name.human} was successfully updated." } 
      }
      if params.nil?
        @default_update_valid ||= Default.new(default_params)
      else
        params.reverse_merge!(default_params)
        @default_update_valid = Default.new(params[:type], params[:message])
      end
    end

    def update_invalid(params = nil)
      default_params = { 
        type: :alert, 
        message: -> (resource) { "#{resource.model_name.human} failed to be updated." } 
      }
      if params.nil?
        @default_update_invalid ||= Default.new(default_params)
      else
        params.reverse_merge!(default_params)
        @default_update_invalid = Default.new(params[:type], params[:message])
      end
    end

    def destroy(params = nil)
      default_params = { 
        type: :notice, 
        message: -> (resource) { "#{resource.model_name.human} was successfully destroyed." } 
      }
      if params.nil?
        @default_destroy ||= Default.new(default_params)
      else
        params.reverse_merge!(default_params)
        @default_destroy = Default.new(params[:type], params[:message])
      end
    end

    def [](key)
      send(key)
    end

    class Default
      attr_accessor :flash_type, :message_or_block

      def initialize(flash_type, message_or_block)
        @flash_type = flash_type
        @message_or_block = message_or_block
      end

      def message(resource = nil)
        @message_or_block.is_a?(Proc) ? @message_or_block.call(resource) : @message_or_block
      end
    end
  end
end