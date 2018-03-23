require 'spec_helper'

feature 'User resets password' do
  scenario 'user successfully resets password' do
    user = Fabricate(:user)
    visit forgot_password_path

    fill_in "email", with: user.email
    click_button  "Send Email"

    open_email user.email
    current_email.click_link "Reset your password"

    fill_in "password", with: "newpass"
    click_button "Reset Password"

    fill_in "email", with: user.email
    fill_in "password", with: "newpass"
    find('input[value="Sign In"]').click
    expect(page).to have_content("Welcome #{user.full_name}")
  end

end