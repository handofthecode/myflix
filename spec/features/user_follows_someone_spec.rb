require 'spec_helper'

feature 'user follows someone' do
	context 'two users, category, videos, and reviews' do
		background do
			sign_in
		end
    scenario 'add queue_item' do
      leader = Fabricate(:user)
			comedy = Fabricate(:category, name: 'comedy')
			video_1 = Fabricate(:video, category: comedy)
			video_2 = Fabricate(:video, category: comedy)
      video_3 = Fabricate(:video, category: comedy)
      Review.create(user: leader, video: video_1, content: 'blah', rating: 3)
			
			visit videos_path
			find("a[href=\"/videos/#{video_1.id}\"]").click
			expect(page).to have_content video_1.title

			click_link leader.full_name
			expect(page).to have_content leader.full_name

      click_link "Follow"
      expect(page).to have_content "#{leader.full_name}'s Reviews"
      
      click_link "People"
      expect(page).to have_content leader.full_name
      expect(page).to have_content "People I Follow"

      id = Relationship.first.id
      find("a[href=\"/relationships/#{id}\"]").click
      expect(page).not_to have_content leader.full_name
      expect(page).to have_content "People I Follow"
		end
	end

end