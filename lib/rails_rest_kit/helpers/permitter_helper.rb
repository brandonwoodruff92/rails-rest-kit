module RailsRestKit
  module Helpers
    module PermitterHelper
      extend ActiveSupport::Concern

      included do
        class_attribute :permitter, instance_writer: false
        self.permitter = RailsRestKit::Permitter.new
      end

      class_methods do
        def permit_resource(resource_name, required: false, &block)
          permitter.configure(resource_name, required: required, &block)
        end
      end

      private

      def permit_params(resource_name)
        self.class.permitter.permit(resource_name, params)
      end
    end
  end
end