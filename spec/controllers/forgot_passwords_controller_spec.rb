require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context "account exists" do
      let(:user) { Fabricate(:user, email: 'testtest@hotmail.com') }
      context "valid email"
        before do
          post :create, email: user.email
        end
        it "redirects to sign in page" do
          expect(response).to redirect_to forgot_password_confirmation_path
        end
        it "shows a success message" do
          expect(flash[:success]).to eq("Reset email has been sent to #{user.email}")
        end
        it "sends an email to the address" do
          expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        end
      end
      context "email not in database" do
        before do
          post :create, email: 'doesntexist@hotmail.com'
        end
        it "redirects to forgot_password page" do
          expect(response).to redirect_to forgot_password_path
        end
        it "shows error message" do
          expect(flash[:error]).to eq("Email not associated with account")
        end
      end
      context "email is blank" do
        before do
          post :create, email: ''
        end
        it "redirects to forgot_password page" do
          expect(response).to redirect_to forgot_password_path
        end
        it "shows error message" do
          expect(flash[:error]).to eq("Email field must not be blank")
        end
      end
  end
end