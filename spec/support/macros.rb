def authenticate(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(user = nil)
	user = user || Fabricate(:user)
	visit sign_in_path
	fill_in 'email', with: user.email
	fill_in 'password', with: user.password
	click_button "Sign in"
end