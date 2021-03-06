require 'spec_helper'
INVALID_PERSON = {full_name: 'bob bobbers', password: 'password'}
CUSTOMER_ID = 'abcd'
CUSTOMER_JSON =	'{"id": "abcd"}'

describe UserSignup do
  describe "#sign_up", :vcr do
    context "valid card info" do
      before do
				customer = double(:customer, successful?: true, response: CUSTOMER_JSON)
				StripeWrapper::Customer.stub(:create).and_return(customer)
				Stripe::Subscription.stub(:create)
			end

			context "invalid personal info" do
				it "does not create the user" do
					UserSignup.new(User.new(INVALID_PERSON)).sign_up("stripeToken", nil)
					expect(User.count).to eq(0)
				end
				it "should not charge credit card" do
					expect(StripeWrapper::Customer).not_to receive(:create)
					UserSignup.new(User.new(INVALID_PERSON)).sign_up("stripeToken", nil)
				end
			end

			context "valid personal info" do
				it "creates the user" do
					UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil)
					expect(User.count).to eq(1)
				end
				it "stores the payment id on user" do
					UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil)
					expect(User.first.customer_id).to eq(CUSTOMER_ID)
				end
				it "should charge credit card" do
					expect(StripeWrapper::Customer).to receive(:create)
					UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil)
				end
			end

			context "valid input with valid invite token" do
				let(:inviter) { Fabricate(:user) }
				let(:invitation) { Fabricate(:invitation, inviter: inviter) }
				before do
					UserSignup.new(Fabricate.build(:user, email: invitation.recipient_email)).sign_up("stripeToken", invitation.token)
				end
				it "automatically connects inviter and new user. Each follows the other." do
					new_user = User.find_by_email(invitation.recipient_email)
					expect(inviter.followers).to include(new_user)
					expect(new_user.followers).to include(inviter)
				end
			end

			context "sending sign up mailer" do
				before do
					ActionMailer::Base.deliveries.clear
				end
				it "sends out email to user with valid inputs" do
					UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil)
					user = User.first
					expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
				end
				it "sends out email containing users name" do
					UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil)
					user = User.first
					expect(ActionMailer::Base.deliveries.last.body).to include(user.full_name)
				end
				it "does not send out email with invalid inputs" do
					UserSignup.new(User.new(INVALID_PERSON)).sign_up("stripeToken", nil)
					expect(ActionMailer::Base.deliveries).to be_empty
				end
			end
		end

		context "invalid card info" do
			before do
				customer = double(:customer, successful?: false, error_message: 'Charge failed.')
				StripeWrapper::Customer.stub(:create).and_return(customer)
				Stripe::Subscription.stub(:create)
			end
			
			context "valid personal data input" do
				before { UserSignup.new(Fabricate.build(:user)).sign_up("stripeToken", nil) }
				it "does not create the user" do
					expect(User.count).to eq(0)
				end
			end
		end
  end
end