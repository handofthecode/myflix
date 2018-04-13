require 'spec_helper'

describe 'Deactivate user on failed charge' do
  let(:event_data) do
    {
      "id" => "evt_1CFweKIcRgydQIvRCRK8693i",
      "object" => "event",
      "api_version" => "2018-02-28",
      "created" => 1523505784,
      "data" => {
        "object" => {
          "id" => "ch_1CFweKIcRgydQIvRqHhWklx9",
          "object" => "charge",
          "amount" => 999,
          "amount_refunded" => 0,
          "application" => nil,
          "application_fee" => nil,
          "balance_transaction" => nil,
          "captured" => false,
          "created" => 1523505784,
          "currency" => "usd",
          "customer" => "cus_CfHCRrYi2FMzxo",
          "description" => nil,
          "destination" => nil,
          "dispute" => nil,
          "failure_code" => "card_declined",
          "failure_message" => "Your card was declined.",
          "fraud_details" => {
          },
          "invoice" => nil,
          "livemode" => false,
          "metadata" => {
          },
          "on_behalf_of" => nil,
          "order" => nil,
          "outcome" => {
            "network_status" => "declined_by_network",
            "reason" => "generic_decline",
            "risk_level" => "normal",
            "seller_message" => "The bank did not return any further details with this decline.",
            "type" => "issuer_declined"
          },
          "paid" => false,
          "receipt_email" => nil,
          "receipt_number" => nil,
          "refunded" => false,
          "refunds" => {
            "object" => "list",
            "data" => [
            ],
            "has_more" => false,
            "total_count" => 0,
            "url" => "/v1/charges/ch_1CFweKIcRgydQIvRqHhWklx9/refunds"
          },
          "review" => nil,
          "shipping" => nil,
          "source" => {
            "id" => "card_1CFweIIcRgydQIvRH3MuW2Ad",
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
            "customer" => "cus_CfHCRrYi2FMzxo",
            "cvc_check" => "pass",
            "dynamic_last4" => nil,
            "exp_month" => 12,
            "exp_year" => 2019,
            "fingerprint" => "Dwqj8Opx4Cf72PO3",
            "funding" => "credit",
            "last4" => "0341",
            "metadata" => {
            },
            "name" => nil,
            "tokenization_method" => nil
          },
          "source_transfer" => nil,
          "statement_descriptor" => "1 month of myflix",
          "status" => "failed",
          "transfer_group" => nil
        }
      },
      "livemode" => false,
      "pending_webhooks" => 1,
      "request" => {
        "id" => "req_pZLWqdf5BGSXVk",
        "idempotency_key" => nil
      },
      "type" => "charge.failed"
    }
  end

  it "deactivates user with the webhook data from stripe for charge failed", :vcr do
    user = Fabricate(:user, customer_id: "cus_CfHCRrYi2FMzxo")
    post "/stripe_events", event_data
    expect(user.reload).not_to be_active
  end
end