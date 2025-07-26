class PostsController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  permit_resource :post do
    require :title
    expect :content
    nested :user do
      attributes :name, :email
    end
  end
end