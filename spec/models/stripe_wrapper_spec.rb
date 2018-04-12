require 'spec_helper'
describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {  
        :number => 4242424242424242,
        :exp_month => 4,
        :exp_year => 2030,
        :cvc => "314"
      }
    ).id
  end
  let(:invalid_token) do
    Stripe::Token.create(
      :card => {  
        :number => 4000000000000002,
        :exp_month => 4,
        :exp_year => 2030,
        :cvc => "314"
      }
    ).id
  end
  describe StripeWrapper::Charge do
    let(:response) do
      StripeWrapper::Charge.create(
        amount: 300,
        source: token,
        email: 'yahoo@yahoo.com'
      )
      end

    context "with valid card", :vcr do
      let(:token) {valid_token}
      it "charges the card successfully" do
        expect(response).to be_successful
      end
    end

    context "with invalid card", :vcr do
      let(:token) {invalid_token}
      it "does not charge the card" do
        expect(response).not_to be_successful
      end
      it "has an error message" do
        expect(response.status).to eq(:error)
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      it "creates a customer with valid card" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: valid_token
        )
        expect(response).to be_successful
      end
      it "returns the customer id for a valid card" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: valid_token
        )
        expect(response.customer_id).to be_present
      end
      it "does not create a customer with invalid card" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: invalid_token
        )
        expect(response).not_to be_successful
      end
      it "returns error message with invalid card" do
        user = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: user,
          source: invalid_token
        )
        expect(response.error_message).to be_present
      end
    end
  end
end