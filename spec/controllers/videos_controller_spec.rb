require 'spec_helper'

describe VideosController do
	describe "GET show" do
		let(:video) { Fabricate(:video) }
	  context "with authenticated user" do
	  	before { authenticate }
			it "sets the @video variable" do
				get :show, id: video.id
				expect(assigns(:video)).to eq(video)
			end
			it "sets the @reviews variable" do
				review1 = Fabricate(:review, video: video)
				review2 = Fabricate(:review, video: video)
				get :show, id: video.id
				expect(assigns(:reviews)).to match_array [review1, review2]
			end
		end
		context "with unauthenticated user" do
			it "redirects to the signin page" do
				get :show, id: video.id
				expect(response).to redirect_to sign_in_path
			end
		end
	end



	describe "GET search" do
		let(:video) { Fabricate(:video, title: "Die Hard") }
		context "with authenticated user" do
			before { authenticate }
			it "it sets the @result variable" do
				get :search, search: "ar"
				expect(assigns(:results)).to eq([video])
			end 
		end
		context "with unauthenticated user" do
			it "redirects to sign_in page" do
				get :search, search: "ar"
				expect(response).to redirect_to sign_in_path
			end
		end
	end
end

def authenticate
	session[:user_id] = Fabricate(:user).id
end