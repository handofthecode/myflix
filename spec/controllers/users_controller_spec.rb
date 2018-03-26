require 'spec_helper'
INVALID_PERSON = {full_name: 'bob bobbers', password: 'password'}

describe UsersController do
	describe "GET new" do
		it "sets @user to new instance of User" do
			get :new
			expect(assigns(:user)).to be_a(User)
		end
	end

	describe "POST create" do
		context "valid input" do
			before { post :create, user: Fabricate.attributes_for(:user) }
			it "creates the user" do
				expect(User.count).to eq(1)
			end
			it "redirects to sign_in when params are valid" do
				expect(response).to redirect_to sign_in_path
			end
		context "valid input with valid invite token" do
			let(:inviter) { Fabricate(:user) }
			let(:invitation) { Fabricate(:invitation, inviter: inviter) }
			before do
				post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
			end
			it "automatically connects inviter and new user. Each follows the other." do
				new_user = User.find_by_email(invitation.recipient_email)
				expect(inviter.followers).to include(new_user)
				expect(new_user.followers).to include(inviter)
			end
		end
		end

		context "sending sign up mailer" do
			before { ActionMailer::Base.deliveries.clear }
			it "sends out email to user with valid inputs" do
				post :create, user: {email: "bob@hotmail.com", password: "password", full_name: "bob bobberson"}
				expect(ActionMailer::Base.deliveries.last.to).to eq(["bob@hotmail.com"])
			end
			it "sends out email containing users name" do
				post :create, user: {email: "bob@hotmail.com", password: "password", full_name: "bob bobberson"}
				expect(ActionMailer::Base.deliveries.last.body).to include("bob bobberson")
			end
			it "does not send out email with invalid inputs" do
				post :create, user: {email: "bob@hotmail.com"}
				expect(ActionMailer::Base.deliveries).to be_empty
			end
		end

		context "invalid input" do
			before { post :create, user: INVALID_PERSON }
			it "does not create the user" do
				expect(User.count).to eq(0)
			end
			it "rerenders new template when params are invalid" do
				expect(response).to render_template :new 
			end
			it "assigns @user to be instance of User" do
				expect(assigns(:user)).to be_a(User)
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
