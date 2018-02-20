require 'spec_helper'

describe SessionsController do
	describe "GET new" do
		it "renders the new template for unauthenticated users" do
			get :new
			expect(response).to render_template :new
		end
		it "redirects to videos#index for authenticated users" do
			authenticate
			get :new
			expect(response).to redirect_to videos_path
 		end
	end

	describe "POST create" do
		context "user authenticated" do
			let(:user) { Fabricate(:user) }
			before { post :create, email: user.email, password: user.password }
			it "puts the signed in user in the session" do
				expect(session[:user_id]).to eq(user.id)
			end
			it "redirects to videos#index" do
				expect(response).to redirect_to videos_path
 			end
		end

		context "user not authenticated" do
			before { post :create }
			it "does not put the user in the session" do
				expect(session[:user_id]).to be_nil
			end
			it "renders new template" do
				expect(response).to redirect_to sign_in_path
			end
		end
	end

	describe "POST destroy" do
		context "user authenticated then logged out" do
			before { authenticate; delete :destroy }
			it "teminates the session" do
				expect(session[:user_id]).to be_nil
			end
			it "redirects to root" do
				expect(response).to redirect_to root_path
			end
		end
	end
end

