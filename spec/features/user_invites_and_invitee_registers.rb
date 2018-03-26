require 'spec_helper'

feature 'user invites and invitee registers' do
  scenario 'add queue_item' do
    user = sign_in
    click_link 'Invite Friends'
    fill_in "Friend's Name", with: 'Sam Sammerson'
    fill_in "Friend's Email Address", with: 'sam@hotmail.com'
    fill_in "Invitation Message", with: 'Join up Sam!'
    find('input[value="Send Invitation"]').click
    sign_out

    open_email "sam@hotmail.com"
    expect(current_email).to have_content "You are invited to join MyFlix by your friend #{user.full_name}!"
    current_email.click_link "Accept this invitation"
    expect(page).to have_content "Register"

    fill_in "Password", with: 'password'
    find('input[value="Sign Up"]').click

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button "Sign In"
  
    click_link 'People'
    expect(page).to have_content user.full_name
  end
end