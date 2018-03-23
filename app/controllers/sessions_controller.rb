class SessionsController < ApplicationController
	def new
		redirect_to videos_path if logged_in?
	end
	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			init_session user
		else
			flash[:error] = "There is something wrong with your Email or Password."
			redirect_to :sign_in
		end
	end
	def destroy
		session[:user_id] = nil
		flash[:success] = 'You have logged out.'
		redirect_to root_path
	end

	private

	def init_session(user)
		session[:user_id] = user.id
		flash[:success] = "You are logged in!"
		redirect_to videos_path
	end
end