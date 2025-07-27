require "spec_helper"

RSpec.describe RailsRestKit::Helpers::ResourceHelper, type: :controller do
  controller(UsersController) do
    include RailsRestKit::Helpers::ResourceHelper
  end

  before do
    User.create(name: "John Doe", email: "john.doe@example.com")
    User.create(name: "Jane Doe", email: "jane.doe@example.com")
  end

  let(:user) { User.first }
  let(:users) { User.all }

  describe "setter helpers" do
    it "defines show model_slug setter" do
      controller.params = ActionController::Parameters.new(id: user.id)
      expect(controller.send(:set_user)).to eq(user)
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to eq(user)
    end

    it "defines new model_slug setter" do
      expect(controller.send(:set_new_user)).to be_present
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to be_a_new(User)
    end

    it "defines index model_slugs setter" do
      expect(controller.send(:set_users)).to eq(users)
      expect(assigns(:users)).to be_present
      expect(assigns(:users)).to eq(users)
    end
  end

  describe "class method helpers" do
    it "has the correct model name" do
      expect(controller.model_name).to eq("User")
    end

    it "has the correct resource name" do
      expect(controller.resource_name).to eq("User")
    end

    it "has the correct model slug" do
      expect(controller.model_slug).to eq("user")
    end

    it "has the correct resource slug" do
      expect(controller.resource_slug).to eq("user")
    end

    it "has the correct model class" do
      expect(controller.model_class).to eq(User)
    end

    it "has the correct resource class" do
      expect(controller.resource_class).to eq(User)
    end
  end
end