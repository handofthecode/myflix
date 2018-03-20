class UsersController < ApplicationController
	before_filter :require_user, only: [:show]
	def show
		@user = User.find(params[:id])
	end
	def new
		@user = User.new
	end
	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to sign_in_path
		else
			render :new
		end
	end

	def user_params
		params.require(:user).permit(:full_name, :password, :email)
	end
end