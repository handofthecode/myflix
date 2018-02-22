require 'spec_helper'

describe Video do
	it {should belong_to :category}
	it {should validate_presence_of :description }
	it {should validate_presence_of :title }
	it {should have_many(:reviews).order("created_at DESC")}

	describe "#search_by_title" do
		context 'three videos created' do
			let(:monk) { Fabricate(:video, title: 'Monk') }
			let(:skunk) { Fabricate(:video, title: 'Skunk') }
			let(:honk) { Fabricate(:video, title: 'Honk') }

			it "returns an empty array if there is no match" do
				expect(Video.search_by_title('notavideo')).to eq([])
			end
			it "returns one video for one exact match" do
				expect(Video.search_by_title('Monk')).to eq([monk])
			end
			it "returns one video for one partial match" do
				expect(Video.search_by_title('kun')).to eq([skunk])
			end
			it "returns an array of matches ordered by 'created_at'" do
				monk.created_at = 1.day.ago
				expect(Video.search_by_title('nk')).to eq([skunk, monk])
			end
			it "returns an empty array if user searches for an empty string" do
				expect(Video.search_by_title('')).to eq([])
			end
		end
	end

	describe "#average_rating" do
		context 'video and 2 reviews' do
			let(:monk) { Fabricate(:video, title: 'Monk') }
			before do
				Fabricate(:review, rating: 1, video: monk)
				Fabricate(:review, rating: 5, video: monk)
			end

			it "returns the average of all the associated review's ratings" do
				expect(monk.average_rating).to eq(3)
			end
		end
	end
end