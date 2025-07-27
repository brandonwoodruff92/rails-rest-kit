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

      def permit_params(resource_name, required: false)
        self.class.permitter.permit(resource_name, params, required: required)
      end
    end
  end
end

# permitter.configure :blog_post do
#   require :blog_post
#   attributes :title, :body
#   nested :author do
#     attributes :name, :email
#     nested :profile do
#       attributes :bio
#     end
#   end
#   collection :comments do
#     attributes :content
#     nested :user do
#       attributes :username
#     end
#   end
# end