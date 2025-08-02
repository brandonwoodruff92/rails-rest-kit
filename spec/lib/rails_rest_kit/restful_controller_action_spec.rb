require "spec_helper"

RSpec.describe UsersController, type: :controller do
  describe "index_callbacks" do
    let(:users) do 
      User.create(name: "John Doe", email: "john.doe@example.com")
      User.create(name: "Jane Doe", email: "jane.doe@example.com")
      User.all
    end

    before { users }

    it "runs callbacks in the proper order" do
      callback_order = []
      controller.class.before_index { callback_order << "before_index" }
      controller.class.after_index { callback_order << "after_index" }
      get :index
      expect(callback_order).to eq(["before_index", "after_index"])
    end

    it "sets the users instance variable" do
      get :index
      expect(assigns(:users)).to be_present
      expect(assigns(:users)).to eq(users)
    end
  end

  describe "show_callbacks" do
    let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

    before { user }

    it "runs callbacks in the proper order" do
      callback_order = []
      controller.class.before_show { callback_order << "before_show" }
      controller.class.after_show { callback_order << "after_show" }
      get :show, params: { id: user.id }
      expect(callback_order).to eq(["before_show", "after_show"])
    end

    it "sets the user instance variable" do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "new_callbacks" do
    it "runs callbacks in the proper order" do
      callback_order = []
      controller.class.before_new { callback_order << "before_new" }
      controller.class.after_new { callback_order << "after_new" }
      get :new
      expect(callback_order).to eq(["before_new", "after_new"])
    end

    it "sets the new user instance variable" do
      get :new
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "create_callbacks" do
    it "runs callbacks in the proper order when valid" do
      callback_order = []
      controller.class.before_create { callback_order << "before_create" }
      controller.class.before_create_valid { callback_order << "before_create_valid" }
      controller.class.before_create_invalid { callback_order << "before_create_invalid" }
      controller.class.after_create { callback_order << "after_create" }
      controller.class.after_create_valid { callback_order << "after_create_valid" }
      controller.class.after_create_invalid { callback_order << "after_create_invalid" }
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com" } }
      expect(flash[:notice]).to eq("User was successfully created.")
      expect(callback_order).to eq(["before_create", "before_create_valid", "after_create_valid", "after_create"])
    end

    it "runs callbacks in the proper order when invalid" do
      callback_order = []
      controller.class.before_create { callback_order << "before_create" }
      controller.class.before_create_valid { callback_order << "before_create_valid" }
      controller.class.before_create_invalid { callback_order << "before_create_invalid" }
      controller.class.after_create { callback_order << "after_create" }
      controller.class.after_create_valid { callback_order << "after_create_valid" }
      controller.class.after_create_invalid { callback_order << "after_create_invalid" }
      post :create, params: { user: {} }
      expect(flash[:alert]).to eq("User failed to be created.")
      expect(callback_order).to eq(["before_create", "before_create_invalid", "after_create_invalid", "after_create"])
    end

    it "uses flash default overrides" do
      RailsRestKit.config.flash_defaults.create_valid(type: :alert, message: "Custom message")
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com" } }
      expect(flash[:alert]).to eq("Custom message")
      expect(flash[:notice]).to be_nil
      RailsRestKit.config.flash_defaults.create_valid(type: :alert, message: -> (resource) { "Custom message 2" })
      post :create, params: { user: { name: "Jane Doe", email: "jane.doe@example.com" } }
      expect(flash[:alert]).to eq("Custom message 2")
      expect(flash[:notice]).to be_nil
    end

    it "sets the user instance variable" do
      post :create, params: { user: { name: "John Doe", email: "john.doe@example.com" } }
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to be_a(User)
      expect(assigns(:user).name).to eq("John Doe")
      expect(assigns(:user).email).to eq("john.doe@example.com")
    end
  end

  describe "edit_callbacks" do
    let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

    before { user }

    it "runs callbacks in the proper order" do
      callback_order = []
      controller.class.before_edit { callback_order << "before_edit" }
      controller.class.after_edit { callback_order << "after_edit" }
      get :edit, params: { id: user.id }
      expect(callback_order).to eq(["before_edit", "after_edit"])
    end

    it "sets the user instance variable" do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "update_callbacks" do
    let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

    before { user }

    it "runs callbacks in the proper order when valid" do
      callback_order = []
      controller.class.before_update { callback_order << "before_update" }
      controller.class.before_update_valid { callback_order << "before_update_valid" }
      controller.class.before_update_invalid { callback_order << "before_update_invalid" }
      controller.class.after_update { callback_order << "after_update" }
      controller.class.after_update_valid { callback_order << "after_update_valid" }
      controller.class.after_update_invalid { callback_order << "after_update_invalid" }
      put :update, params: { id: user.id, user: { name: "Jane Doe", email: "jane.doe@example.com" } }
      expect(flash[:notice]).to eq("User was successfully updated.")
      expect(callback_order).to eq(["before_update", "before_update_valid", "after_update_valid", "after_update"])
    end

    it "runs callbacks in the proper order when invalid" do
      callback_order = []
      controller.class.before_update { callback_order << "before_update" }
      controller.class.before_update_valid { callback_order << "before_update_valid" }
      controller.class.before_update_invalid { callback_order << "before_update_invalid" }
      controller.class.after_update { callback_order << "after_update" }
      controller.class.after_update_valid { callback_order << "after_update_valid" }
      controller.class.after_update_invalid { callback_order << "after_update_invalid" }
      put :update, params: { id: user.id, user: { name: nil } }
      expect(flash[:alert]).to eq("User failed to be updated.")
      expect(callback_order).to eq(["before_update", "before_update_invalid", "after_update_invalid", "after_update"])
    end

    it "uses flash default overrides" do
      RailsRestKit.config.flash_defaults.update_valid(type: :alert, message: "Custom message")
      put :update, params: { id: user.id, user: { name: "Test" } }
      expect(flash[:alert]).to eq("Custom message")
      expect(flash[:notice]).to be_nil
      RailsRestKit.config.flash_defaults.update_valid(type: :alert, message: -> (resource) { "Custom message 2" })
      put :update, params: { id: user.id, user: { name: "Test 2" } }
      expect(flash[:alert]).to eq("Custom message 2")
      expect(flash[:notice]).to be_nil
    end

    it "sets the user instance variable" do
      put :update, params: { id: user.id, user: { name: "Jane Doe", email: "jane.doe@example.com" } }
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to eq(user)
      expect(assigns(:user).name).to eq("Jane Doe")
      expect(assigns(:user).email).to eq("jane.doe@example.com")
    end
  end

  describe "destroy_callbacks" do
    let(:user) { User.create(name: "John Doe", email: "john.doe@example.com") }

    before { user }

    it "runs callbacks in the proper order when valid" do
      callback_order = []
      controller.class.before_destroy { callback_order << "before_destroy" }
      controller.class.before_destroy_valid { callback_order << "before_destroy_valid" }
      controller.class.before_destroy_invalid { callback_order << "before_destroy_invalid" }
      controller.class.after_destroy { callback_order << "after_destroy" }
      controller.class.after_destroy_valid { callback_order << "after_destroy_valid" }
      controller.class.after_destroy_invalid { callback_order << "after_destroy_invalid" }
      delete :destroy, params: { id: user.id }
      expect(flash[:notice]).to eq("User was successfully destroyed.")
      expect(callback_order).to eq(["before_destroy", "before_destroy_valid", "after_destroy_valid", "after_destroy"])
    end

    it "runs callbacks in the proper order when invalid" do
      allow_any_instance_of(User).to receive(:destroy) do |user|
        user.errors.add(:base, "Cannot destroy user")
        false
      end
      callback_order = []
      controller.class.before_destroy { callback_order << "before_destroy" }
      controller.class.before_destroy_valid { callback_order << "before_destroy_valid" }
      controller.class.before_destroy_invalid { callback_order << "before_destroy_invalid" }
      controller.class.after_destroy { callback_order << "after_destroy" }
      controller.class.after_destroy_valid { callback_order << "after_destroy_valid" }
      controller.class.after_destroy_invalid { callback_order << "after_destroy_invalid" }
      delete :destroy, params: { id: user.id }
      expect(flash[:alert]).to eq("User failed to be destroyed.")
      expect(callback_order).to eq(["before_destroy", "before_destroy_invalid", "after_destroy_invalid", "after_destroy"])
    end

    it "destroys the user" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it "uses flash default overrides" do
      RailsRestKit.config.flash_defaults.destroy_valid(type: :alert, message: "Custom message")
      delete :destroy, params: { id: user.id }
      expect(flash[:alert]).to eq("Custom message")
      expect(flash[:notice]).to be_nil
      RailsRestKit.config.flash_defaults.destroy_valid(type: :alert, message: -> (resource) { "Custom message 2" })
      user = User.create!(name: "John Doe", email: "john.doe@example.com")
      delete :destroy, params: { id: user.id }
      expect(flash[:alert]).to eq("Custom message 2")
      expect(flash[:notice]).to be_nil
    end

    it "sets the user instance variable" do
      delete :destroy, params: { id: user.id }
      expect(assigns(:user)).to be_present
      expect(assigns(:user)).to eq(user)
    end
  end
end