require 'spec_helper'

describe ReviewsController do
	describe 'POST create review' do
		context 'user is authenticated' do
			let(:user) { Fabricate :user }
			let(:video) { Fabricate :video }
			before { authenticate user }

			context 'form is completed' do
				before {post :create, review: Fabricate.attributes_for(:review), video_id: video.id}
				it 'redirects to video show page' do
					expect(response).to redirect_to video
				end

				it 'adds review to the database' do
					expect(Review.all.size).to eq(1)
				end
				it 'adds review to user' do
					expect(Review.first.user).to eq(user)
				end
				it 'adds review to video' do
					expect(video.reviews.first).to eq(Review.first)
				end
			end
			context 'review content is blank' do
				before {post :create, review: {rating: 2}, video_id: video.id}
				it 'no review is added' do
					expect(Review.all).to be_empty
				end
				it 'renders the video show template' do
					expect(response).to render_template 'videos/show'
				end
				it 'sets @video' do
					expect(assigns(:video)).to eq(video)
				end
				it 'sets @reviews' do
					expect(assigns(:reviews)).to eq(user.reviews)
				end
				# it 'has error message' do
				# 	expect(assigns(:reviews)).to 
				# end
			end
		end
		context 'user is not authenticated' do
			let(:video) { Fabricate :video }
			it 'redirects to sign in' do
				post :create, review: Fabricate.attributes_for(:review), video_id: video.id
				expect(response).to redirect_to sign_in_path
			end
		end
	end
end
