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
		result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])
		if result.successful?
			flash[:success] = result.success_message
			redirect_to sign_in_path
		else
			flash[:error] = result.error_message
			render :new
		end
	end

	private

	def user_params
		params.require(:user).permit(:full_name, :password, :email)
	end
end
