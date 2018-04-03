def authenticate(user = nil)
	user = user || Fabricate(:user)
	session[:user_id] = user.id 
	user
end

def sign_in(user = nil)
	user = user || Fabricate(:user)
	visit sign_in_path
	fill_in 'email', with: user.email
	fill_in 'password', with: user.password
	click_button "Sign In"
	user
end

def sign_out
	find('a#dlabel').click
	find('a[href="/logout"]').click
end