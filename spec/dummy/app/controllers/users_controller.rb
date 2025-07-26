class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  permit_resource :user do
    require :name
    expect :email
    collection :posts do
      attributes :title, :content
    end
  end
end