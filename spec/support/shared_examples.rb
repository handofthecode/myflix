shared_examples "requires sign in" do
	it "redirects to the sign in page" do
		session[:user_id] = nil
		action
		expect(response).to redirect_to sign_in_path
	end
end

shared_examples "tokenable" do
	it "generates and assigns a random token" do
		expect(object.token).to be_present
	end
end

shared_examples "requires admin" do
	context 'not admin' do
		let(:user) { Fabricate(:user) }
		before { authenticate user; get :new }
		it "redirects to root path for regular user" do
			expect(response).to redirect_to(root_path)
		end
		it "sets flash error message for regular user" do
			expect(flash[:error]).to be_present
		end
	end
end