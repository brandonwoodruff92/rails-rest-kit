require "spec_helper"

# RSpec.describe UsersController, type: :controller do
#   it "has a permitter" do
#     expect(controller.permitter).to be_a(RailsRestKit::Permitter)
#   end

#   it "is configured with the correct attributes" do 
#     configurations = controller.permitter.configurations
#     expect(configurations).to have_key("user")
#     user_config = configurations["user"]
#     expect(user_config.required).to be false
#     expect(user_config.attributes).to eq(["name", "email"])
#     expect(user_config.nested_attributes).to be_empty
#     expect(user_config.collections).to have_key("posts")
#     posts_config = user_config.collections["posts"]
#     expect(posts_config.attributes).to eq(["title", "content"])
#     expect(posts_config.nested_attributes).to be_empty
#     expect(posts_config.collections).to be_empty
#   end

#   it "can set the required flag" do
#     controller.class.permit_resource :user, required: true do
#       attributes :name, :email
#     end
#     configurations = controller.permitter.configurations
#     expect(configurations).to have_key("user")
#     user_config = configurations["user"]
#     expect(user_config.required).to be true
#   end

#   it "can permit the correct params" do
#     params = ActionController::Parameters.new(user: { name: "John Doe", email: "john.doe@example.com" })
#     result = controller.send(:permit_params, "user")
#     expect(result).to be_a(ActionController::Parameters)
#     expect(result.permitted?).to be true
#     expect(result.to_unsafe_h).to eq({ "name" => "John Doe", "email" => "john.doe@example.com" })
#   end
# end

RSpec.describe RailsRestKit::Helpers::PermitterHelper, type: :controller do
  controller(ApplicationController) do
    include RailsRestKit::Helpers::PermitterHelper
  end

  before do
    controller.class.permit_resource :user do
      attributes :name, :email
      collection :posts do
        attributes :title, :content
      end
    end
  end

    it "has a permitter" do
    expect(controller.permitter).to be_a(RailsRestKit::Permitter)
  end

  it "is configured with the correct attributes" do 
    configurations = controller.permitter.configurations
    expect(configurations).to have_key("user")
    user_config = configurations["user"]
    expect(user_config.required).to be false
    expect(user_config.attributes).to eq(["name", "email"])
    expect(user_config.nested_attributes).to be_empty
    expect(user_config.collections).to have_key("posts")
    posts_config = user_config.collections["posts"]
    expect(posts_config.attributes).to eq(["title", "content"])
    expect(posts_config.nested_attributes).to be_empty
    expect(posts_config.collections).to be_empty
  end

  it "can set the required flag" do
    controller.class.permit_resource :user, required: true do
      attributes :name, :email
    end
    configurations = controller.permitter.configurations
    expect(configurations).to have_key("user")
    user_config = configurations["user"]
    expect(user_config.required).to be true
  end

  it "can permit the correct params" do
    params = ActionController::Parameters.new(user: { name: "John Doe", email: "john.doe@example.com" })
    controller.params = params
    result = controller.send(:permit_params, "user")
    expect(result).to be_a(ActionController::Parameters)
    expect(result.permitted?).to be true
    expect(result.to_unsafe_h).to eq({ "name" => "John Doe", "email" => "john.doe@example.com" })
  end
end