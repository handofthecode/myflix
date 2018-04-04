require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do
  background do
    visit register_path
  end
  scenario 'with valid user info and valid card info' do
    valid_user_info
    valid_card_info
    find('input[value="Sign Up"]').click
    sleep 1
    expect(page).to have_content("Welcome Bob Biggins! You can now sign in.")
  end

  scenario 'with valid user info and invalid card info' do
    valid_user_info
    invalid_card_info
    find('input[value="Sign Up"]').click
    sleep 1
    expect(page).to have_content("Your card was declined.")
  end

  scenario 'with invalid user info and invalid card info' do
    invalid_user_info
    valid_card_info
    find('input[value="Sign Up"]').click
    sleep 1
    expect(page).to have_content("can't be blank")
  end

end

def valid_user_info
  fill_in 'user_email', with: 'biggins@hotmail.com'
  fill_in 'user_password', with: 'password'
  fill_in 'user_full_name', with: 'Bob Biggins'
end

def invalid_user_info
  fill_in 'user_full_name', with: 'Bob Biggins'
end

def valid_card_info
  within_frame(find('iframe[name="__privateStripeFrame3"]')) do
    fill_in 'cardnumber', with: '4242 4242 4242 4242'
    fill_in 'exp-date', with: '1219'
    fill_in 'cvc', with: '123'
    fill_in 'postal', with: '98112'
  end
end

def invalid_card_info
  within_frame(find('iframe[name="__privateStripeFrame3"]')) do
    fill_in 'cardnumber', with: '4000 0000 0000 0002'
    fill_in 'exp-date', with: '1219'
    fill_in 'cvc', with: '123'
    fill_in 'postal', with: '98112'
  end
end
