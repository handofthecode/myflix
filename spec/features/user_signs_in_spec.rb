require 'spec_helper'

feature 'User signs in' do
	scenario 'with existing username' do
		sign_in
		expect(page).to have_content User.first.full_name
	end
end