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
end