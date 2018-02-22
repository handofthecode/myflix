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
		context 'user not authenticated' do
			it 'redirects to sign_in' do
				get :index
				expect(response).to redirect_to sign_in_path
			end
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
				item = QueueItem.find_by video_id: video.id
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
		context 'user not authenticated' do
			let(:video) { Fabricate(:video) }
			it 'redirects to sign_in page' do
				post :create, video_id: video.id
				expect(response).to redirect_to sign_in_path
			end
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
			it 'nothing is deleted if the request id is not in the video queue' do
				item_1 = Fabricate(:queue_item, user: user, video: video, position: 1)
				first_item_count = user.queue_items.count
				delete :destroy, id: item_1.id + 1
				second_item_count = user.queue_items.count
				expect(second_item_count).to eq(first_item_count)
			end
		end
		context 'user not authenticated' do
			it 'redirects to sign in page' do
				delete :destroy, id: 1
				expect(response).to redirect_to sign_in_path
			end
		end
	end
end