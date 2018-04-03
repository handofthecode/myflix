require 'spec_helper'

feature 'user invites and invitee registers' do
  scenario 'add queue_item', {js: true, vcr: true} do
    user = sign_in
    click_link 'Invite Friends'
    fill_in "Friend's Name", with: 'Big Biggins'
    fill_in "Friend's Email Address", with: 'biggins@hotmail.com'
    fill_in "Invitation Message", with: 'Join up Big!'
    find('input[value="Send Invitation"]').click
    sign_out

    open_email "biggins@hotmail.com"
    expect(current_email).to have_content "You are invited to join MyFlix by your friend #{user.full_name}!"
    current_email.click_link "Accept this invitation"
    expect(page).to have_content "Register"

    fill_in 'user_email', with: 'biggins@hotmail.com'
    fill_in 'user_password', with: 'password'
    within_frame(find('iframe[name="__privateStripeFrame3"]')) do
      fill_in 'cardnumber', with: '4242 4242 4242 4242 123 1219 99508'
    end
    find('input[value="Sign Up"]').click

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button "Sign In"
    click_link 'People'
    expect(page).to have_content user.full_name
  end
end