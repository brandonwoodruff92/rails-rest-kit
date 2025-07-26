module RailsRestKit
  module Helpers
    module ResourceHelper
      extend ActiveSupport::Concern

      included do
        # Set show resource
        define_method("set_#{model_slug}") do
          instance_variable_set("@#{model_slug}", model_class.find(params[:id])) if !instance_variable_get("@#{model_slug}")
          instance_variable_get("@#{model_slug}")
        end
        # Set new resource
        define_method("set_new_#{model_slug}") do
          instance_variable_set("@#{model_slug}", model_class.new) if !instance_variable_get("@#{model_slug}")
          instance_variable_get("@#{model_slug}")
        end
        # Set index resources
        define_method("set_#{model_slug.pluralize}") do
          instance_variable_set("@#{model_slug.pluralize}", model_class.all) if !instance_variable_get("@#{model_slug.pluralize}")
          instance_variable_get("@#{model_slug.pluralize}")
        end
      end

      class_methods do
        def model_name
          @model_name ||= controller_name.classify
        end
        alias_method :resource_name, :model_name

        def model_slug
          @model_slug ||= controller_name.singularize
        end
        alias_method :resource_slug, :model_slug

        def model_class
          @model_class ||= model_name.constantize
        end
        alias_method :resource_class, :model_class
      end
    end
  end
end