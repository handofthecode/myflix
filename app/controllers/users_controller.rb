class UsersController < ApplicationController
	before_filter :require_user, only: [:show]
	def show
		@user = User.find_by_token(params[:id])
	end
	def new
		@user = User.new
	end
	def new_with_invitation_token
		invitation = Invitation.find_by_token(params[:token])
		if invitation
			@user = User.new(email: invitation.recipient_email, full_name: invitation.recipient_name)
			@invitation_token = invitation.token
			render :new
		else
			redirect_to expired_token_path
		end
	end
	def create
		@user = User.new(user_params)
		if @user.save
			handle_invitation_relationships
			AppMailer.send_welcome_email(@user).deliver
			redirect_to sign_in_path
		else
			render :new
		end
	end

	private

	def handle_invitation_relationships
		if !params[:invitation_token].blank?
			invitation = Invitation.find_by_token(params[:invitation_token])
			connect_two_users(@user, invitation.inviter)
		end
	end
	def connect_two_users(user_1, user_2)
		user_1.follow user_2
		user_2.follow user_1
	end
	def user_params
		params.require(:user).permit(:full_name, :password, :email)
	end
end
