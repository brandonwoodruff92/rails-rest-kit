class UsersController < ApplicationController
  include RailsRestKit::RestfulControllerActions

  permit_resource :user, required: true do
    attributes :name, :email
    collection :posts do
      attributes :title, :content
    end
  end
end