require 'spec_helper'

describe QueueItem do
	it { should belong_to(:user) }
	it { should belong_to(:video) }
	it { should validate_numericality_of(:position).only_integer }

	context 'video and category' do
		category = Category.create(name: 'Action')
		let(:video) { Fabricate(:video, title: 'Die Hard', category: category) }
		let(:queue_item) { Fabricate(:queue_item, video: video) }

		describe '#video_title' do
			it 'returns the title of the associated video' do
				expect(queue_item.video_title).to eq('Die Hard') 
			end
		end

		describe '#video_category' do
			it 'returns the category of the associated video' do
				expect(queue_item.video_category).to eq('Action')
			end
		end

		describe '#video_id' do
			it 'returns the id of the associated video' do
				expect(queue_item.video_id).to eq(video.id)
			end
		end

		describe '#rating' do
			it 'returns the rating of the associated video if rating exists' do
				review = Fabricate(:review, rating: 4)
				video.reviews << review
				expect(queue_item.rating).to eq(4)
			end
			it 'returns nil from the associated video if the rating does not exist' do
				expect(queue_item.rating).to eq(nil)
			end
		end
	end
end