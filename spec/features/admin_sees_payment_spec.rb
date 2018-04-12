require 'spec_helper'

describe "admin sees payments" do
  before do
    user = Fabricate(:user)
    Fabricate(:payment, amount: 999, user: user)
  end
  scenario "admin can see payments" do
    user = User.first
    sign_in Fabricate(:admin)
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content(user.full_name)
    expect(page).to have_content(user.email)

  end
  scenario "admin cannot see payments" do
    user = User.first
    sign_in Fabricate(:user)
    visit admin_payments_path
    expect(page).not_to have_content("$9.99")
    expect(page).not_to have_content(user.full_name)
    expect(page).not_to have_content(user.email)
  end

end