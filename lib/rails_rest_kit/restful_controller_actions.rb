module RailsRestKit
  module RestfulControllerActions
    extend ActiveSupport::Concern

    RESTFUL_ACTIONS = {
      index: %i[],
      show: %i[],
      new: %i[],
      create: %i[ valid invalid ],
      edit: %i[],
      update: %i[ valid invalid ],
      destroy: %i[]
    }

    included do
      include RailsRestKit::Helpers::PermitterHelper
      include RailsRestKit::Helpers::ResourceHelper

      define_restful_actions_and_callbacks
    end

    private

    def default_index
      run_callbacks(:index) do
        send("set_#{model_slug.pluralize}")
      end
    end

    def default_show
      run_callbacks(:show) do
        send("set_#{model_slug}")
      end
    end

    def default_new
      run_callbacks(:new) do
        send("set_new_#{model_slug}")
      end
    end

    def default_create
      resource = send("set_new_#{model_slug}")
      resource.assign_attributes(permit_params(model_slug))
      run_callbacks(:create) do
        if resource.save
          run_callbacks(:create_valid) do
          end
        else
          run_callbacks(:create_invalid) do
          end
        end
      end
    end

    def default_edit
      run_callbacks(:edit) do
        send("set_#{model_slug}")
      end
    end

    def default_update
      resource = send("set_#{model_slug}")
      resource.assign_attributes(permit_params(model_slug))
      run_callbacks(:update) do
        if resource.save
          run_callbacks(:update_valid) do
          end
        else
          run_callbacks(:update_invalid) do
          end
        end
      end
    end

    def default_destroy
      resource = send("set_#{model_slug}")
      run_callbacks(:destroy) do
        resource.destroy
      end
    end

    class_methods do
      def define_restful_actions_and_callbacks
        RESTFUL_ACTIONS.each do |action, hooks|
          define_callbacks(action)
          hooks.each do |hook|
            define_callbacks("#{action}_#{hook}")
          end
          %i[ before after around ].each do |callback|
            define_singleton_method("#{callback}_#{action}") do |*args, &block|
              set_callback(action, callback, &block)
            end
            hooks.each do |hook|
              define_singleton_method("#{callback}_#{action}_#{hook}") do |*args, &block|
                set_callback("#{action}_#{hook}", callback, &block)
              end
            end
          end
          define_method(action) do
            send("default_#{action}")
          end
        end
      end
    end
  end
end