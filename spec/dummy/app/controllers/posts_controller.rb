class PostsController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  permit_resource :post do
    attributes :title, :content
    nested :user do
      attributes :name, :email
    end
  end
end