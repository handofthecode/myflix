require 'spec_helper'

describe UsersController do
	describe "GET new" do
		it "sets @user to new instance of User" do
			get :new
			expect(assigns(:user)).to be_a(User)
		end
	end

	describe "POST create" do
		context "successfull" do
			before do
				result = double(:sign_up_result, successful?: true, success_message: 'success message!')
				UserSignup.any_instance.should_receive(:sign_up).and_return(result)
				post :create, user: Fabricate.attributes_for(:user)
			end
			it "redirects to sign_in when params are valid" do
				expect(response).to redirect_to sign_in_path
			end
			it "sets flash success" do
				expect(flash[:success]).to be_present
			end
		end
		context "unsuccessfull" do
			before do
				result = double(:sign_up_result, successful?: false, error_message: 'Sign up failed.')
				UserSignup.any_instance.should_receive(:sign_up).and_return(result)
				post :create, user: Fabricate.attributes_for(:user)
			end
			it "redirects to sign_in when params are valid" do
				expect(response).to render_template :new
			end
			it "assigns @user to be instance of User" do
				expect(assigns(:user)).to be_a(User)
			end
			it "sets flash success" do
				expect(flash[:error]).to be_present
			end
		end
	end

	describe "GET new_with_invitation_token" do
		context "invitation with valid token" do
			let(:invitation) { Fabricate(:invitation) }
			before do
				get :new_with_invitation_token, token: invitation.token
			end
			it "renders the :new view template" do
				expect(response).to render_template :new
			end
			it "sets @user with recipient's email set" do
				expect(assigns(:user).email).to eq(invitation.recipient_email)
			end
			it "sets the invitation token on @user" do
				expect(assigns(:invitation_token)).to eq(invitation.token)
			end
		end
		context "invitation with invalid token" do
			before do
				get :new_with_invitation_token, token: 'not valid token'
			end
			it "redirects to expired token page for invalid tokens" do
				expect(response).to redirect_to expired_token_path
			end
		end
	end

	describe "GET show" do
		it_behaves_like "requires sign in" do
			let(:action) { get :show, id: 1 }
		end
		it "sets @user" do
			authenticate
			sam = Fabricate(:user)
			get :show, id: sam.token
			expect(assigns(:user)).to eq(sam)
		end
	end
end
