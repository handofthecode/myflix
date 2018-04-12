require 'spec_helper'

describe 'Create payment on successful charge', :vcr do
  let(:event_data) do
    {
      "id" => "evt_1CFUPYIcRgydQIvRbiMMurAN",
      "object" => "event",
      "api_version" => "2018-02-28",
      "created" => 1523397236,
      "data" => {
        "object" => {
          "id" => "ch_1CFUPXIcRgydQIvRu51ypDxp",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => "txn_1CFUPXIcRgydQIvRoUH1nofk",
          "captured" => true,
          "created" => 1523397235,
          "currency" => "usd",
          "customer" => "cus_Ceo1FxosmdF621",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => nil,
          "failure_message" => nil,
          "fraud_details" => {
          },
          "invoice" => "in_1CFUPXIcRgydQIvRMg0Dv7tO",
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "approved_by_network",
            "reason" => nil,
            "risk_level" => "normal",
            "seller_message" => "Payment complete.",
            "type" => "authorized"
          },
          "paid" => true,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1CFUPXIcRgydQIvRu51ypDxp/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1CFUPWIcRgydQIvRc6eHNnyz",
            "object" => "card",
            "address_city" => nil,
            "address_country" => nil,
            "address_line1" => nil,
            "address_line1_check" => nil,
            "address_line2" => nil,
            "address_state" => nil,
            "address_zip" => "98112",
            "address_zip_check" => "pass",
            "brand" => "Visa",
            "country" => "US",
            "customer" => "cus_Ceo1FxosmdF621",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2019,
            "fingerprint" => "Hytx7AQsQDPpePyZ",
            "funding" => "credit",
            "last4" => "4242",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "1 month of myflix",
          "status" => "succeeded",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => {
        "id" => "req_lbcavWsYy7ftPf",
        "idempotency_key" => nil
      },
      "type" => "charge.succeeded"
    }
  end
  it "creates a payment with the webhook from stripe for charge succeeded" do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
  it "creates a payment associated with user" do
    user = Fabricate(:user, customer_id: "cus_Ceo1FxosmdF621")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(user)
  end
  it "creates the payment with the amount" do
    user = Fabricate(:user, customer_id: "cus_Ceo1FxosmdF621")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end
  it "creates the payment with the reference_id" do
    user = Fabricate(:user, customer_id: "cus_Ceo1FxosmdF621")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_1CFUPXIcRgydQIvRu51ypDxp")
  end
end