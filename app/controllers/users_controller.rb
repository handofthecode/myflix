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
			@user = User.new(email: invitation.recipient_email, invitation_token: invitation.token)
			render :new
		else
			redirect_to expired_token_path
		end
	end
	def create
		@user = User.new(user_params)
		if @user.save
			set_following_relationships
			AppMailer.send_welcome_email(@user).deliver
			redirect_to sign_in_path
		else
			render :new
		end
	end

	private
	
	def set_following_relationships
		if @user.invitation_token
			invitation = Invitation.find_by_token(@user.invitation_token)
			connect_two_users(@user, invitation.inviter)
		end
	end
	def connect_two_users(user_1, user_2)
		Relationship.create(follower: user_1, leader: user_2)
		Relationship.create(follower: user_2, leader: user_1)
	end
	def user_params
		params.require(:user).permit(:full_name, :password, :email, :invitation_token)
	end
end