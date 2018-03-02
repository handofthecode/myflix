require 'spec_helper'

feature 'User adds video to my_queue' do
	context 'with user, videos and queue_items' do
		background do
			sign_in
		end
		scenario 'add queue_item' do
			# let(:comedy) { Fabricate(:category, name: 'comedy') }
			# let(:video_1) { Fabricate(:video, category: comedy) }
			# let(:video_2) { Fabricate(:video, category: comedy) }
			# let(:video_3) { Fabricate(:video, category: comedy) }
			comedy = Fabricate(:category, name: 'comedy')
			video_1 = Fabricate(:video, category: comedy)
			video_2 = Fabricate(:video, category: comedy)
			video_3 = Fabricate(:video, category: comedy)
			
			visit videos_path
			find("a[href=\"/videos/#{video_1.id}\"]").click
			page.should have_content video_1.title

			click_link "+ My Queue"
			expect(page).to have_content 'Video Title'

			visit video_path(video_1)
			page.should_not have_content "+ My Queue"

			click_link "Videos"
			find("a[href=\"/videos/#{video_2.id}\"]").click
			click_link "+ My Queue"

			click_link "Videos"
			find("a[href=\"/videos/#{video_3.id}\"]").click
			click_link "+ My Queue"

			fill_in "video_#{video_1.id}", with: 2
			fill_in "video_#{video_2.id}", with: 3
			fill_in "video_#{video_3.id}", with: 1

			click_button "Update Instant Queue"

			expect(find("#video_#{video_1.id}").value).to eq("2")
			expect(find("#video_#{video_2.id}").value).to eq("3")
			expect(find("#video_#{video_3.id}").value).to eq("1")

		end
	end

end