require 'spec_helper'

describe Video do
	it {should belong_to :category}
	it {should validate_presence_of :description }
	it {should validate_presence_of :title }
	it {should have_many(:reviews).order("created_at DESC")}
end

describe "#search_by_title" do
	it "returns an empty array if there is no match" do
		monk = Video.create({title: 'Monk', description: 'funny man'})
		skunk = Video.create({title: 'Skunk', description: 'funny skunk'})
		honk = Video.create({title: 'Honk', description: 'honk honk'})
		expect(Video.search_by_title('notamovie')).to eq([])
	end
	it "returns one video for one exact match" do
		monk = Video.create({title: 'Monk', description: 'funny man'})
		skunk = Video.create({title: 'Skunk', description: 'funny skunk'})
		expect(Video.search_by_title('Monk')).to eq([monk])
	end
	it "returns one video for one partial match" do
		monk = Video.create({title: 'The Monk', description: 'funny man'})
		skunk = Video.create({title: 'Thee Skunk', description: 'funny skunk'})
		expect(Video.search_by_title('Thee')).to eq([skunk])
	end
	it "returns an array of matches ordered by 'created_at'" do
		monk = Video.create({title: 'The Monk', description: 'funny man', created_at: 1.day.ago})
		skunk = Video.create({title: 'The Skunk', description: 'funny skunk'})
		expect(Video.search_by_title('The')).to eq([skunk, monk])
	end
	it "returns an empty array if user searches for an empty string" do
		monk = Video.create({title: 'Monk', description: 'funny man'})
		skunk = Video.create({title: 'Skunk', description: 'funny skunk'})
		honk = Video.create({title: 'Honk', description: 'honk honk'})
		expect(Video.search_by_title('')).to eq([])
	end

end