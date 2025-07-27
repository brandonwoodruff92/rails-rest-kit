require "spec_helper"

RSpec.describe RailsRestKit::Permitter do
  let(:permitter) { RailsRestKit::Permitter.new }

  describe "permitted params" do
    let(:params) { ActionController::Parameters.new(user: { name: "John Doe", email: "john.doe@example.com" }) }

    it "permits the correct params" do
      permitter.configure(:user) do
        attributes :name
      end
      result = permitter.permit(:user, params)
      expect(result).to be_a(ActionController::Parameters)
      expect(result.permitted?).to be true
      expect(result.to_unsafe_h).to eq({ "name" => "John Doe" })
    end
  end

  describe "required params" do
    let(:params) { ActionController::Parameters.new(user: { name: "John Doe", email: "john.doe@example.com" }) }

    it "permits the correct params" do
      permitter.configure(:user, required: true) do
        attributes :name
      end
      result = permitter.permit(:user, params)
      expect(result).to be_a(ActionController::Parameters)
      expect(result.permitted?).to be true
      expect(result.to_unsafe_h).to eq({ "name" => "John Doe" })
    end

    it "raises an error when no params are provided" do
      permitter.configure(:user, required: true) do
        attributes :name
      end
      params = ActionController::Parameters.new
      expect { permitter.permit(:user, params) }.to raise_error(ActionController::ParameterMissing)
      params = ActionController::Parameters.new(user: {})
      expect { permitter.permit(:user, params) }.to raise_error(ActionController::ParameterMissing)
    end
  end

  describe "nested attributes" do
    let(:params) { ActionController::Parameters.new(user: { address: { street: "123 Main St", city: "Anytown", state: "CA" } }) }

    it "permits the correct params" do
      permitter.configure(:user) do
        nested :address do
          attributes :street, :city
        end
      end
      result = permitter.permit(:user, params)
      expect(result).to be_a(ActionController::Parameters)
      expect(result.permitted?).to be true
      expect(result.to_unsafe_h).to eq({ "address" => { "street" => "123 Main St", "city" => "Anytown" } })
    end
  end

  describe "collection attributes" do
    let(:params) { ActionController::Parameters.new(user: { addresses: [{ street: "123 Main St", city: "Anytown", state: "CA" }] }) }

    it "permits the correct params" do
      permitter.configure(:user) do
        collection :addresses do
          attributes :street, :city
        end
      end
      result = permitter.permit(:user, params)
      expect(result).to be_a(ActionController::Parameters)
      expect(result.permitted?).to be true
      expect(result.to_unsafe_h).to eq({ "addresses" => [{ "street" => "123 Main St", "city" => "Anytown" }] })
    end
  end
end