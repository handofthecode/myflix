require 'spec_helper'

describe User do
	it { should validate_presence_of(:email) }
	it { should validate_presence_of(:password) }
	it { should validate_presence_of(:full_name) }
	it { should validate_uniqueness_of(:email) }
	it { should have_many(:queue_items) }

	describe "#in_queue?" do
		context "user and videos" do
			let(:user) { Fabricate(:user) }
			let(:video) { Fabricate(:video) }
			let(:other_video) { Fabricate(:video) }
			before do
				Fabricate(:queue_item, user: user, video: video)
			end
			it "returns true when video or queue_item is in queue" do
				item = QueueItem.first
				expect(user.in_queue?(video) && user.in_queue?(item)).to eq(true)
			end
			it "returns false when video is not in queue" do
				expect(user.in_queue?(other_video)).to eq(false)
			end
		end
	end
end