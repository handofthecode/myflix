require 'spec_helper'

describe Category do
	it { should have_many :videos }

	describe "#recent_videos" do
		it "returns all videos if there are less than 6 videos" do
			z = Category.create name: 'z'
			2.times { Video.create(title: 'x', description: 'y', category: z)}
			expect(z.recent_videos.size).to eq(2)
		end
		it "returns the videos in reverse chronological order" do
			numbers = Category.create name: 'Numbers'
			one = Video.create title: 'one', description: "it's one", category: numbers, created_at: 1.day.ago
			three = Video.create title: 'three', description: "it's three", category: numbers, created_at: 3.days.ago
			zero = Video.create title: 'zero', description: "it's zero", category: numbers
			expect(numbers.recent_videos).to eq([zero, one, three])
		end
		it "returns 6 videos if there are more than 6 videos" do
			z = Category.create name: 'z'
			8.times { Video.create(title: 'x', description: 'y', category: z)}
			expect(z.recent_videos.size).to eq(6)
		end

		it "returns the most recent videos" do
			numbers = Category.create name: 'Numbers'
			middle = Video.create title: 'one', description: "day old", category: numbers, created_at: 1.day.ago
			old = Video.create title: 'three', description: "3 days old", category: numbers, created_at: 3.days.ago
			5.times { Video.create(title: 'now', description: 'most recent', category: numbers)}
			expect(numbers.recent_videos).not_to include(old)
		end

		it "returns an empty array if there are no vidoes" do
			space_goats = Category.create name: 'space goats'
			expect(space_goats.recent_videos).to eq([])
		end
	end
end