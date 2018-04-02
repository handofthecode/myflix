require 'spec_helper'

feature 'Admin adds new video' do
  scenario 'user successfully resets password' do
    sign_in Fabricate(:admin)
    category = Fabricate(:category)
    video = Fabricate.attributes_for(:video, category: category.name)
    visit new_admin_video_path

    fill_in "Title", with: video[:title]
    select video[:category], from: "Category"
    fill_in "Description", with: video[:description]
    attach_file "Large cover", "spec/support/uploads/kidsinthehall_large.jpg"
    attach_file "Small cover", "spec/support/uploads/kidsinthehall.jpg"
    fill_in "Video url", with: "http://www.example.com/myvid.mp4"
    find('input[value="Add Video"]').click
    expect(page).to have_content("#{video[:title]} added successfully!")

    sign_out
    sign_in

    visit video_path Video.first
    expect(page).to have_selector("a[href='http://www.example.com/myvid.mp4']")
    expect(page).to have_selector("img[src='/uploads/kidsinthehall_large.jpg']")
  end
end