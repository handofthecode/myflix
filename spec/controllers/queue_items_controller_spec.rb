require 'spec_helper'

describe QueueItemsController do
	describe "GET index" do
		context 'user authenticated' do
			let(:user) { Fabricate(:user) }
			before do 
				authenticate user
				Fabricate(:queue_item, user: user)
				get :index
			end
			it 'sets @items' do
				expect(assigns(:items)).to eq(user.queue_items)
			end
			it 'renders the queue_items#index page' do
				expect(response).to render_template :index
			end
		end
		it_behaves_like "requires sign in" do
			let(:action) {get :index}
		end
	end

	describe "POST create" do
		context 'user authenticated' do
			let(:user) { Fabricate(:user) }
			let(:video) { Fabricate(:video) }

			before do 
				authenticate user
				post :create, video_id: video.id
			end
			it 'redirects to the my_queue page' do
				expect(response).to redirect_to my_queue_path
			end
			it 'creates a queue_item that is associated with the video' do
				item = QueueItem.find_by video: video
				expect(!!item).to eq(true)
			end
			it 'creates a queue_item that is associated with the signed in user' do
				item = QueueItem.find_by user: user
				expect(!!item).to eq(true)
			end
			it 'puts the new queue_item as the last one in the queue' do
				newestVideo = Fabricate(:video)
				post :create, video_id: newestVideo.id
				expect(user.queue_items.last.position).to eq(video.queue_items.first.position + 1)
			end
			it 'creating a duplicate queue_item should not be possible' do
				post :create, video_id: video.id
				expect(QueueItem.count).to eq(1)
			end
		end
		it_behaves_like "requires sign in" do
			video = Fabricate(:video)
			let(:action) { post :create, video_id: video.id }
		end
	end

	describe "DELETE destroy" do
		context 'user authenticated' do
			let(:user) { Fabricate(:user) }
			let(:video) { Fabricate(:video) }
			before do 
				authenticate user
			end
			it 'deletes queue_item' do
				item_1 = Fabricate(:queue_item, user: user, video: video, position: 1)
				first_item_count = user.queue_items.count
				delete :destroy, id: item_1.id
				second_item_count = user.queue_items.count
				expect(second_item_count).to eq(first_item_count - 1)
			end
			it 'does not delete if the request id is not in the video queue' do
				item_1 = Fabricate(:queue_item, user: user, video: video, position: 1)
				first_item_count = user.queue_items.count
				delete :destroy, id: item_1.id + 1
				second_item_count = user.queue_items.count
				expect(second_item_count).to eq(first_item_count)
			end
			it 'normalizes position after delete' do
				item_1 = Fabricate(:queue_item, user: user, video: video, position: 1)
				item_2 = Fabricate(:queue_item, user: user, video: video, position: 2)
				expect(item_2.position).not_to be(1)
				delete :destroy, id: item_1.id
				item_2.reload
				expect(item_2.position).to eq(1)
			end
		end
		it_behaves_like "requires sign in" do
			let(:action) {delete :destroy, id: 1}
		end
	end

	describe "POST update_queue" do
		it_behaves_like "requires sign in" do
			let(:action) {post :update, queue_items: [{"id" => "1", "position" => "1"}]}
		end
		context 'with user, videos and queue_items' do
			let(:user) { Fabricate(:user) }
			let(:video_1) { Fabricate(:video) }
			let(:video_2) { Fabricate(:video) }
			let(:queue_item_1) {Fabricate(:queue_item, user: user, video: video_1, position: 1)}
			let(:queue_item_2) {Fabricate(:queue_item, user: user, video: video_2, position: 2)}

			context 'with valid inputs' do
				before do 
					authenticate user
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "3"},
																			{"id" => "#{queue_item_2.id}", "position" => "2"}]
				end
				it 'redirects to my_queue_path' do
					expect(response).to redirect_to my_queue_path
				end
				it 're-orders the queue_items' do
					expect(user.queue_items).to eq([queue_item_2, queue_item_1])
				end
				it 'normalizes the position numbers' do
					expect(user.queue_items.map(&:position)).to eq([1, 2])
				end
				it 'has no user rating until rated' do

					expect(user.reviews.find_by video: video_1).to eq(nil)
				end
				it 'has a user rating once rated' do
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "2", "rating" => "5"}]
					rating = user.reviews.find_by(video: video_1).rating
					expect(rating).to eq(5)
				end
				it 'has simple review content once rated' do
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "2", "rating" => "5"}]
					content = user.reviews.find_by(video: video_1).content
					expect(content).to eq(nil)
				end
				it 'preserves content of old review if rated from my_queue page' do
					user.reviews.create({rating: "3", content: "preserve this", video: video_1})
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "2", "rating" => "5"}]
					user.reviews.first.rating
					expect(user.reviews.first.content).to eq("preserve this")
				end

			end
			context 'with invalid inputs' do
				before do 
					authenticate user
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "3"},
																			{"id" => "#{queue_item_2.id - 100}", "position" => "1"}]
				end
				it 'redirects to my_queue' do
					expect(response).to redirect_to my_queue_path
				end
				it 'displays a flash message' do
					expect(flash[:error]).to be_present
				end
				it 'does not change any queue_items' do
					queue_item_1.reload
					expect(queue_item_1.position).to eq(1)
				end
			end
			context 'with un-authenticated user' do
				before { post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "2"}] }
				it 'redirects to sign_in page' do
					expect(response).to redirect_to sign_in_path
				end
				it 'displays a flash message' do
					expect(flash[:error]).to be_present
				end
			end
			context 'with wrong user\'s items' do
				let(:user_2) { Fabricate(:user) }
				before do
					authenticate user_2
					post :update, queue_items: [{"id" => "#{queue_item_1.id}", "position" => "3"}]
					queue_item_1.reload
				end
				it "doesn't change items" do
					expect(queue_item_1.position).to eq(1)
				end
				it 'displays a flash message' do
					expect(flash[:error]).to be_present
				end
			end
		end
	end
end