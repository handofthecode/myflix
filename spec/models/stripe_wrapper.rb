require 'spec_helper'

describe StripeWrapper::Charge do
  before { StripeWrapper.set_api_key }
  let(:token) { 
    Stripe::Token.create(
      :card => {  
        :number => card_number,
        :exp_month => 4,
        :exp_year => 2030,
        :cvc => "314"
      }
    ).id
  }
  let(:response) {
    StripeWrapper::Charge.create(
      amount: 300,
      source: token,
      email: 'yahoo@yahoo.com'
    )
  }

  context "with valid card", :vcr do
    let(:card_number) {4242424242424242}
    it "charges the card successfully" do
      expect(response).to be_successful
    end
  end

  context "with invalid card", :vcr do
    let(:card_number) {4000000000000002}
    it "does not charge the card" do
      expect(response).not_to be_successful
    end
    it "has an error message", :vcr do
      expect(response.status).to eq(:error)
    end
  end
end