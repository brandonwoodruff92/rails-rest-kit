class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  permit_resource :user do
    attributes :name, :email
    collection :posts do
      attributes :title, :content
    end
  end
end